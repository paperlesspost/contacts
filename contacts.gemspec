Gem::Specification.new do |s|
  s.name = "contacts"
  s.version = "1.4.1"
  s.date = "2010-09-20"
  s.summary = "A universal interface to grab contact list information from various providers including Outlook, Address Book, Yahoo, AOL, Gmail, Hotmail, and Plaxo."
  s.homepage = "http://github.com/paperlesspost/contacts"
  s.description = "A universal interface to grab contact list information from various providers including Outlook, Address Book, Yahoo, AOL, Gmail, Hotmail, and Plaxo."
  s.has_rdoc = false
  s.authors = ["Lucas Carlson", "Paperless"]
  s.files = ["LICENSE", "Rakefile", "README", "examples/grab_contacts.rb", "lib/contacts.rb", "lib/contacts/base.rb", "lib/contacts/json_picker.rb", "lib/contacts/gmail.rb", "lib/contacts/aol_importer.rb", "lib/contacts/hotmail.rb", "lib/contacts/plaxo.rb", "lib/contacts/yahoo.rb"]
  s.add_dependency("json", ">= 1.1.1")
  s.add_dependency('gdata19')
  s.add_dependency('nokogiri')
  s.add_dependency('encryptor')
end
