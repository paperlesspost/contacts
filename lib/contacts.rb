$:.unshift(File.dirname(__FILE__)+"/contacts/")

## Use ActiveSupport's version of JSON if available
#if Object.const_defined?('ActiveSupport') && ActiveSupport.const_defined?('JSON')
#  module ActiveSupportJsonParseFunction
#    def parse(i)
#      ActiveSupport::JSON.decode(i)
#    end
#  end
#  # newer versions of ActiveSupport define a root JSON module to extend...
#  if Object.const_defined?('JSON')
#    JSON.send(:extend, ActiveSupportJsonParseFunction)
#  else
#    # ... older need it defined from scratch
#    class JSON
#      extend ActiveSupportJsonParseFunction
#    end
#  end
#else
#  require 'json/add/rails'
#end

require 'json_picker'
require 'base'
require 'gmail'
require 'hotmail'
require 'yahoo'
require 'plaxo'
require 'vcf'
require 'outlook'
require 'aol_importer'
