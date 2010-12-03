require 'csv'

class Contacts
  class Outlook < Base
    
    def initialize(file)
      @contact_file = Array.new
      file.each do |line|
        @contact_file << CSV.parse(line)[0]
      end
      @full_name = false
      @header_indexes = Hash.new
      @header_indexes[:email_address] = Array.new

      headers = @contact_file[0]

      @contact_file = @contact_file[1, @contact_file.length]

      headers.each_with_index do |header, i|
        if header.match(/^Name$/)
          @full_name = true
          @header_indexes[:full_name] = i
        elsif header.match(/^First Name/)
          @header_indexes[:first_name] = i
        elsif header.match(/^Last Name/)
          @header_indexes[:last_name] = i
        elsif header.match(/E-mail/)
          @header_indexes[:email_address] << i
        end
      end
    end
    
    def contacts

      contacts = Array.new
      
      @contact_file.each_with_index do |line, i|
        contacts[i] = Array.new unless contacts[i]
        if(@full_name)
          contacts[i][0] = line[@header_indexes[:full_name]]
        else
          contacts[i][0] = "#{line[@header_indexes[:first_name]]} #{line[@header_indexes[:last_name]]}"
        end
        @header_indexes[:email_address].each do |index|
          if line[index] && !contacts[i][1]
            contacts[i][1] = line[index]
          end
        end
      end
      
      contacts
    end
    
  end
  
  private
    FILETYPES[:outlook] = Outlook
end