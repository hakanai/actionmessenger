$:.unshift(File.dirname(__FILE__) + "/../")
require 'common'

class BaseTest < Test::Unit::TestCase
  def setup
    @messenger = ActionMessenger::MessengerRegistry.find_by_name(:mock)
    @messenger.deliveries = []

    @expected = ActionMessenger::Message.new
    @expected.subject = 'Wake up!'
    @expected.body = 'You told me to remind you to wake up.  Well?'

    SimpleMessenger.received = []
  end
  
  # Tests creating and delivering a simple message.
  def test_creation_and_delivery
    @expected.to = 'trejkaz@trypticon.org/tests'

    # Test creation of the message.
    assert_equal [ @expected ], SimpleMessenger.create_wakeup('trejkaz@trypticon.org/tests')
    
    # Test delivery.
    SimpleMessenger.send_wakeup('trejkaz@trypticon.org/tests')
    assert_equal [ @expected ], @messenger.deliveries
  end

  # Tests creating multiple messages, to send to multiple recipients.
  def test_multiple_recipients
    expected1 = @expected.clone
    expected1.to = 'user1@trypticon.org'
    expected2 = @expected.clone
    expected2.to = 'user2@trypticon.org'

    # Creation
    assert_equal [ expected1, expected2 ],
                 SimpleMessenger.create_wakeup_multi('user1@trypticon.org', 'user2@trypticon.org')

    # Delivery
    SimpleMessenger.send_wakeup_multi('user1@trypticon.org', 'user2@trypticon.org')
    assert_equal [ expected1, expected2],
                 @messenger.deliveries
  end
  
  # Tests receiving a message.
  def test_receiving
    incoming = ActionMessenger::Message.new
    incoming.to = 'trejkaz@trypticon.org/tests'
    incoming.body = 'Ping'
    
    @messenger.fake_received(incoming)
    
    assert_equal [ incoming ], SimpleMessenger.received
  end
  
  # Model class for testing.
  class SimpleMessenger < ActionMessenger::Base
    uses_messenger :mock
    receives_messages
    
    class << self
      attr_accessor :received
    end

    def wakeup(jid)
      recipient jid
      subject   'Wake up!'
      body      'You told me to remind you to wake up.  Well?'
    end

    def wakeup_multi(*jids)
      recipients [*jids]
      subject    'Wake up!'
      body       'You told me to remind you to wake up.  Well?'
    end
    
    def received(message)
      SimpleMessenger.received << message
    end
  end
end
