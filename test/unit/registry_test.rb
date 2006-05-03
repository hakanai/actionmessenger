$:.unshift(File.dirname(__FILE__) + "/../")
require 'common'

# Tests for the messenger registry.
class RegistryTest < Test::Unit::TestCase
  def setup
    @registry = ActionMessenger::MessengerRegistry.new
    @registry.config_file = File.dirname(__FILE__) + "/../files/test-config.yml"
  end
  
  # Tests finding a messenger which we know exists.
  def test_find_by_name
    assert_not_nil @registry.find_by_name('mock')
  end
  
  # Tests finding a messenger which we know doesn't exist.
  def test_find_nonexistent
    assert_raise ActionMessenger::MessengerRegistry::NoSuchMessengerError do
      @registry.find_by_name('bogus')
    end
  end
  
  # Tests finding a messenger which exists in the config but has a bad messenger type.
  def test_invalid_messenger_type
    assert_raise ActionMessenger::MessengerRegistry::NoSuchMessengerTypeError do
      @registry.find_by_name('invalid-type')
    end
  end
  
  # Tests setting in a config file which doesn't exist.
  def test_config_file_nonexistent
    @registry.config_file = File.dirname(__FILE__) + "/../files/nonexistent.yml"
    assert_raise ActionMessenger::MessengerRegistry::NoConfigFileError do
      @registry.config
    end
  end
  
  # Tests registering a messenger directly.
  def test_register
    @registry.register('brandnew', BrandNewMessenger.new)
    assert_kind_of BrandNewMessenger, @registry.find_by_name('brandnew')
  end
  
  # Tests that when in a rails test environment, a mock messenger is returned
  # even when a different type is specified.  We can't actually set the Rails global
  # though, which is a bit sucky.
  def test_mock_messengers
    @registry.mock_messengers = true
    assert_kind_of ActionMessenger::Messengers::MockMessenger, @registry.find_by_name('real')
  end
  
  # Tests that the trick we use to redirect static method calls is working properly.
  def test_singleton_trick
    ActionMessenger::MessengerRegistry.shared_instance = nil
    assert_not_nil ActionMessenger::MessengerRegistry.config_file
  end
  
  # Dummy messenger for the sake of testing manual registration.
  class BrandNewMessenger < ActionMessenger::Messenger
  end
end
