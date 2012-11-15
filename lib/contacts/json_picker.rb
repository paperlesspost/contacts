require 'multi_json'

class Contacts
  def self.parse_json( string )
    MultiJson.decode(string)
  end
end
