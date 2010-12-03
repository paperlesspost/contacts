dir = File.dirname(__FILE__)
require "#{dir}/../test_helper"

class VcfTest < ContactImporterTestCase
  context 'An instance of Vcf' do
    should 'open file properly' do
      vcfobject = Contacts.new(:vcf, File.open(File.dirname(__FILE__) + '/../vCards.vcf'))
      assert_not_nil vcfobject
    end
    
    should 'get contacts from file' do
      vcfobject = Contacts.new(:vcf, File.open(File.dirname(__FILE__) + '/../vCards.vcf'))
      contacts = vcfobject.contacts
      assert_not_nil contacts
    end
  end
end