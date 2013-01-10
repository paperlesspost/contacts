Gem::Specification.new do |s|
  s.name = "contacts"
  s.version = "1.5.6.paperlesspost"
  s.date = "2013-01-10"
  s.summary = "A universal interface to grab contact list information from various providers including Outlook, Address Book, Yahoo, AOL, Gmail, Hotmail, and Plaxo."
  s.homepage = "http://github.com/paperlesspost/contacts"
  s.description = "A universal interface to grab contact list information from various providers including Outlook, Address Book, Yahoo, AOL, Gmail, Hotmail, and Plaxo."
  s.has_rdoc = false
  s.authors = ["Lucas Carlson", "Paperless Post"]
  s.files = `git ls-files`.split($\)
  s.add_dependency("multi_json", "~>1.3")
  s.add_dependency('gdata', '1.1.1.paperlesspost')
  s.add_dependency('hpricot')
  s.add_dependency('nokogiri')
  s.add_dependency('encryptor')
end
