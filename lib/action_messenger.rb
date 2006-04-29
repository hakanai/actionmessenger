
$:.unshift(File.dirname(__FILE__) + "/../vendor/xmpp4r/lib")

require 'action_messenger/base'
require 'action_messenger/message'
require 'action_messenger/messenger_registry'
require 'action_messenger/messenger'
require 'action_messenger/messengers/mock_messenger'
require 'action_messenger/messengers/xmpp4r_messenger'

require 'xmpp4r'
require 'yaml'
