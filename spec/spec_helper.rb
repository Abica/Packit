require File.join( File.dirname( __FILE__ ), "..", "lib", "packit" )
 
module Packit
  module Test
    module Helper
			# MUWAHAHAHAHAHAH!@!!!!!@!
    end
  end
end
 
Spec::Runner.configure do |config|
  config.include Packit::Test::Helper
end
