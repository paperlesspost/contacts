Gem::Specification.new do |s|
  s.name = "pp-contacts"
  s.version = "1.5.2"
  s.date = "2012-04-26"
  s.summary = "A universal interface to grab contact list information from various providers including Outlook, Address Book, Yahoo, AOL, Gmail, Hotmail, and Plaxo."
  s.homepage = "http://github.com/paperlesspost/contacts"
  s.description = "A universal interface to grab contact list information from various providers including Outlook, Address Book, Yahoo, AOL, Gmail, Hotmail, and Plaxo."
  s.has_rdoc = false
  s.authors = ["Lucas Carlson", "Paperless"]
  s.files = `git ls-files`.split($\)
  s.add_dependency("json", ">= 1.1.1")
  s.add_dependency('gdata19')
  s.add_dependency('hpricot')
  s.add_dependency('nokogiri')
  s.add_dependency('encryptor')
end
