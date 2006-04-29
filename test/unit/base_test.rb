$:.unshift(File.dirname(__FILE__) + "/../../lib/")

class BaseTest < Test::Unit::TestCase
  def setup
    @messenger = ActionMessenger::Messengers::MockMessenger.new
    registry = ActionMessenger::MessengerRegistry.new
    registry.register(:mock, @messenger)
    ActionMessenger::MessengerRegistry.shared_instance = registry
    @expected = ActionMessenger::Message.new
  end
  
  # Tests creating and delivering a simple message.
  def test_creation_and_delivery
    @expected.to = 'trejkaz@trypticon.org'
    @expected.subject = 'Wake up!'
    @expected.body = 'You told me to remind you to wake up.  Well?'
    
    # Test creation of the message.
    assert_equal @expected, SimpleMessenger.create_wakeup('trejkaz@trypticon.org')
    
    # Test delivery.
    SimpleMessenger.send_wakeup('trejkaz@trypticon.org')
    assert_equal [ @expected ], @messenger.deliveries
  end

  # Model class for testing.
  class SimpleMessenger < ActionMessenger::Base
    uses_messenger :mock

    def wakeup(jid)
      message.to = jid
      message.subject = 'Wake up!'
      message.body = 'You told me to remind you to wake up.  Well?'
    end
  end
end

