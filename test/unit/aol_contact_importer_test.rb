dir = File.dirname(__FILE__)
require "#{dir}/../test_helper"
require 'contacts'

class AolContactImporterTest < ContactImporterTestCase
  def setup
    super
    @account = TestAccounts[:aol]
  end

  def test_successful_login
    Contacts.new(:aolImporter, @account.username, @account.password)
  end

  def test_importer_fails_with_blank_password
    assert_raise(Contacts::AuthenticationError) do
      Contacts.new(:aolImporter, @account.username, "")
    end
  end

  def test_importer_fails_with_blank_username
    assert_raise(Contacts::AuthenticationError) do
      Contacts.new(:aolImporter, "", @account.password)
    end
  end

  def test_fetch_contacts
    contacts = Contacts.new(:aolImporter, @account.username, @account.password).contacts
    @account.contacts.each do |contact|
      assert contacts.include?(contact), "Could not find: #{contact.inspect} in #{contacts.inspect}"
    end
  end

  def test_parse_contacts_with_quote
    data = %{
FirstName,LastName,ScreenName,NickName,E-mail,E-mail2,Phone1,Phone1Type,Phone2,Phone2Type,Phone3,Phone3Type,Phone4,Phone4Type,Phone5,Phone5Type,Category,Company,JobTitle,Department,BusinessStreet,BusinessStreet2,BusinessStreet3,BusinessCity,BusinessState,BusinessPostalCode,BusinessCountry ,HomeStreet,HomeStreet2,HomeStreet3,HomeCity,HomeState,HomePostalCode,HomeCountry,Spouse,FamilyNames,Birthday,Anniversary,Notes,DisplayName,PreferredEmail,WebPage,DefaultPostalAddress,Locale,BusinessURL,
"FirstName1","LastName1",,,"firstname1@example.com",,,,,,,,,,,,"Uncategorized",,,,,,,,,,,,,,,,,,,,,,,,"Email1",,,,,
"FirstName2","LastName2",,,"firstname2@example.com",,,,,,,,,,,,"Uncategorized",,,,,,,,,,,,,,,,,,,,,,,,"Email1",,,,,
"Gordon'B","Digs",,,"w'hat@aol.com",,"","Cellular","","Cellular","","Cellular","","Cellular","","Cellular","Uncategorized",,,,,,,,,,,,,,,,,,,,,,,,"Email1",,,,,
"lol","",,,"lol@wut.tf",,,,,,,,,,,,"Uncategorized",,,,,,,,,,,,,,,,,,,,,,,,"Email1",,,,,
"Name "with quote","Last Name",,,"test@paperlesspost.com",",,,,,,,,,,,,"Uncategorized",,,,,,,,,,,,,,,,,,,,,,,,"Email1",,,,,
"Special","Char",,,"question@mark.fr",,,,,,,,,,,,"Uncategorized",,,,,,,,,,,,,,,,,,,,,,,,"Email1",,,,,
"xdfasdf,asdfasdf,asdf","",,,,,,,,,,,,,,,"Uncategorized",,,,,,,,,,,,,,,,,,,,,,,,"ScreenName",,,,,
"name\r\nwithlines",,,,"paperlesspost@paperlesspost.com",,,,,,,,,,,,"Auto-Added",,,,,,,,,,,,,,,,,,,,,,,,"Email1",,,,,
    }

    contacts = Contacts.new(:aolImporter, @account.username, @account.password).parse(data)

  end
end
