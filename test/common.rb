$:.unshift(File.dirname(__FILE__) + "/../lib/")
$:.unshift(File.dirname(__FILE__))

require 'test/unit'
require 'action_messenger'

# Override the configuration...
ActionMessenger::MessengerRegistry.config_file = File.dirname(__FILE__) + "/files/test-config.yml"
