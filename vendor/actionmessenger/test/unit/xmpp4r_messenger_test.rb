# Tests for the XMPP4R messenger.
class Xmpp4rMessengerTest < Test::Unit::TestCase
  def setup
    registry = ActionMessenger::MessengerRegistry.new
    registry.config_file = File.dirname(__FILE__) + "/../files/test-config.yml"
    
    @messenger = registry.find_by_name('real')
  end
  
  def teardown
    @messenger.shutdown
  end
  
  # Tests sending a message (to ourselves.)
  def test_send
    message = ActionMessenger::Message.new
    message.to = @messenger.config['jid']
    message.body = 'Test body'
    message.subject = 'Test subject'
    @messenger.send_message(message)
    
    # TODO: Confirm receipt of the same message.
    sleep(0.5)
  end

  # Dummy messenger for the sake of testing resolving something that's already a messenger.
  class BrandNewMessenger < ActionMessenger::Messenger
  end
end
