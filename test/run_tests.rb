$:.unshift(File.dirname(__FILE__) + "/../lib/")
$:.unshift(File.dirname(__FILE__))

require 'test/unit'
require 'action_messenger'

# Override the configuration...
ActionMessenger::MessengerRegistry.config_file = File.dirname(__FILE__) + "/files/test-config.yml"

# Unit tests
require 'unit/registry_test'
require 'unit/messenger_test'
require 'unit/base_test'

# These ones require network connectivity and a valid jid/password combination in the config.
require 'unit/xmpp4r_messenger_test'
