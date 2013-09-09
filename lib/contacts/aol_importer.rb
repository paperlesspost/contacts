require 'hpricot'
require 'csv'

class Contacts
  class AolImporter < Base
    URL                 = "http://www.aol.com/"
    LOGIN_URL           = "https://my.screenname.aol.com/_cqr/login/login.psp"
    LOGIN_REFERER_URL   = "http://webmail.aol.com/"
    LOGIN_REFERER_PATH  = "sitedomain=sns.webmail.aol.com&lang=en&locale=us&authLev=0&uitype=mini&loginId=&redirType=js&xchk=false"
    AOL_NUM             = "35752-111" # this seems to change each time they change the protocol

    CONTACT_LIST_URL     = "http://mail.aol.com/#{AOL_NUM}/aol-6/en-us/Lite/ContactList.aspx"
    CONTACT_LIST_CSV_URL = "http://mail.aol.com/#{AOL_NUM}/aol-6/en-us/Lite/ABExport.aspx?command=all"
    PROTOCOL_ERROR       = "AOL has changed its protocols, please upgrade this library first. If that does not work, dive into the code and submit a patch at http://github.com/cardmagic/contacts"

    def contacts
      postdata = {
        "file" => 'contacts',
        "fileType" => 'csv'
      }

      return @contacts if @contacts
      if connected?
        data, resp, cookies, forward, old_url = get(CONTACT_LIST_URL, @cookies, CONTACT_LIST_URL) + [CONTACT_LIST_URL]

        until forward.nil?
          data, resp, cookies, forward, old_url = get(forward, cookies, old_url) + [forward]
        end

        if resp.code_type != Net::HTTPOK
          raise ConnectionError, self.class.const_get(:PROTOCOL_ERROR)
        end

        # parse data and grab <input name="user" value="8QzMPIAKs2" type="hidden">
        doc = Hpricot(data)
        (doc/:input).each do |input|
          postdata["user"] = input.attributes["value"] if input.attributes["name"] == "user"
        end

        data, resp, cookies, forward, old_url = get(CONTACT_LIST_CSV_URL, @cookies, CONTACT_LIST_URL) + [CONTACT_LIST_URL]

        until forward.nil?
          data, resp, cookies, forward, old_url = get(forward, cookies, old_url) + [forward]
        end

        if data.include?("error.gif")
          raise AuthenticationError, "Account invalid"
        end

        parse data
      end
    end


    def real_connect
      login.gsub!(/@aol.com/, '') # strip off the @aol.com for AOL logins

      postdata = {
        "loginId" => login,
        "password" => password,
        "rememberMe" => "on",
        "_sns_fg_color_" => "",
        "_sns_err_color_" => "",
        "_sns_link_color_" => "",
        "_sns_width_" => "",
        "_sns_height_" => "",
        "offerId" => "mail-second-en-us",
        "_sns_bg_color_" => "",
        "sitedomain" => "sns.webmail.aol.com",
        "regPromoCode" => "",
        "mcState" => "initialized",
        "uitype" => "std",
        "siteId" => "",
        "lang" => "en",
        "locale" => "us",
        "authLev" => "0",
        "siteState" => "",
        "isSiteStateEncoded" => "false",
        "use_aam" => "0",
        "seamless" => "novl",
        "aolsubmit" => CGI.escape("Sign In"),
        "idType" => "SN",
        "usrd" => "",
        "doSSL" => "",
        "redirType" => "",
        "xchk" => "false"
      }

      # Get this cookie and stick it in the form to confirm to Aol that your cookies work
      data, resp, cookies, forward = get(URL)
      postdata["stips"] = cookie_hash_from_string(cookies)["stips"]
      postdata["tst"] = cookie_hash_from_string(cookies)["tst"]

      data, resp, cookies, forward, old_url = get(LOGIN_REFERER_URL, cookies) + [URL]
      until forward.nil?
        data, resp, cookies, forward, old_url = get(forward, cookies, old_url) + [forward]
      end

      data, resp, cookies, forward, old_url = get("#{LOGIN_URL}?#{LOGIN_REFERER_PATH}", cookies) + [LOGIN_REFERER_URL]
      until forward.nil?
        data, resp, cookies, forward, old_url = get(forward, cookies, old_url) + [forward]
      end

      doc = Hpricot(data)
      (doc/:input).each do |input|
        postdata["usrd"] = input.attributes["value"] if input.attributes["name"] == "usrd"
      end
      # parse data for <input name="usrd" value="2726212" type="hidden"> and add it to the postdata

      postdata["SNS_SC"] = cookie_hash_from_string(cookies)["SNS_SC"]
      postdata["SNS_LDC"] = cookie_hash_from_string(cookies)["SNS_LDC"]
      postdata["LTState"] = cookie_hash_from_string(cookies)["LTState"]

      data, resp, cookies, forward, old_url = post(LOGIN_URL, h_to_query_string(postdata), cookies, LOGIN_REFERER_URL) + [LOGIN_REFERER_URL]

      until forward.nil?
        data, resp, cookies, forward, old_url = get(forward, cookies, old_url) + [forward]
      end

      if data.index("Invalid Username or Password. Please try again.")
        raise AuthenticationError, "Username and password do not match"
      elsif data.index("Required field must not be blank")
        raise AuthenticationError, "Login and password must not be blank"
      elsif data.index("errormsg_0_logincaptcha")
        raise AuthenticationError, "Captcha error"
      elsif data.index("Invalid request")
        raise ConnectionError, PROTOCOL_ERROR
      elsif cookies == ""
        raise ConnectionError, PROTOCOL_ERROR
      end

      @cookies = cookies
    end


    def parse(data, options={})
      new_data = []
      # AOL has some bad data sent with their CSVs so we have to do some processing
      data.each_line do |line|
        line = line.strip
        next if line == ""
        line = line.gsub(/,$/, '') # remove trailing comma
        line = line.gsub(/([^,^])"([^,])/, '\1\2') # remove quotes inside quoted fields
        line = line.gsub(/,",/, ',,') # remove weird single quote fields that AOL throws in
        begin
          new_data << CSV.parse(line.strip).flatten
        rescue CSV::MalformedCSVError => e
          # AOL returns really bad data sometimes and though we do what we can,
          # certain cases (such as a ," inside a field) are not easily corrected.
          # So, we just stop at that row and return what we have.
        end
      end
      #data = []
      #begin
        #CSV.parse(new_data.strip) do |row|
        #  data << row
        #end
      col_names = new_data.shift
      @contacts = new_data.map do |person|
        ["#{person[0]} #{person[1]}", person[4]] if person[4] && !person[4].empty?
      end.compact
    end

    def h_to_query_string(hash)
      u = ERB::Util.method(:u)
      hash.map{ |k, v| u.call(k) + "=" + u.call(v) }.join("&")
    end
  end
  TYPES[:aolImporter] = AolImporter
end
