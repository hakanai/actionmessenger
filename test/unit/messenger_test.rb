$:.unshift(File.dirname(__FILE__) + "/../")
require 'common'

# Tests for the messenger.
class MessengerTest < Test::Unit::TestCase
  def setup
    @registry = ActionMessenger::MessengerRegistry.new
    @registry.config_file = File.dirname(__FILE__) + "/../files/test-config.yml"
    ActionMessenger::MessengerRegistry.shared_instance = @registry
  end
  
  # Tests resolving a messenger through various means.
  def test_resolve
    # This guy is already a messenger.
    assert_kind_of BrandNewMessenger, ActionMessenger::Messenger.resolve(BrandNewMessenger.new)
    
    # Strings and symbols are the main cases we care about.
    assert_kind_of ActionMessenger::Messengers::MockMessenger, ActionMessenger::Messenger.resolve('mock')
    assert_kind_of ActionMessenger::Messengers::MockMessenger, ActionMessenger::Messenger.resolve(:mock)
  end

  # Dummy messenger for the sake of testing resolving something that's already a messenger.
  class BrandNewMessenger < ActionMessenger::Messenger
  end
end
