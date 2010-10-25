require 'gdata'

class Contacts
  class Gmail < Base
    
    CONTACTS_SCOPE = 'http://www.google.com/m8/feeds/'
    CONTACTS_FEED = CONTACTS_SCOPE + 'contacts/default/full/?max-results=1000'
    
    GROUP_FEED = "http://www.google.com/m8/feeds/groups/default/base/6"
    
    def contacts
      return @contacts if @contacts
    end
    
    def real_connect
      @client = GData::Client::Contacts.new
      @client.clientlogin(@login, @password, @captcha_token, @captcha_response)
      
      groups = @client.get(GROUP_FEED).to_xml
      
      group_url = groups.elements.to_a('id').collect.first.text
      
      full_feed = group_url.blank? CONTACTS_FEED ? CONTACTS_FEED + "&group=#{group_url}"
      
      feed = @client.get(full_feed).to_xml
      
      @contacts = feed.elements.to_a('entry').collect do |entry|
        title, email = entry.elements['title'].text, nil
        entry.elements.each('gd:email') do |e|
          email = e.attribute('address').value if e.attribute('primary')
        end
        [title, email] unless email.nil?
      end
      @contacts.compact!
    rescue GData::Client::AuthorizationError => e
      raise AuthenticationError, "Username or password are incorrect"
    end
  end
  TYPES[:gmail] = Gmail
end
