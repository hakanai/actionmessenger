require File.dirname(__FILE__) + '/../test_helper'
require 'simple_messenger'

class SimpleMessengerTest < Test::Unit::TestCase
  def setup
    @mock_messenger = ActionMessenger::Messenger.find_by_name(RAILS_ENV)
    @expected = ActionMessenger::Message.new
  end
  
  def test_wakeup
    @expected.to = 'trejkaz@trypticon.org'
    @expected.body = 'Wake up!'
    
    # Test creation of the message.
    assert_equal @expected, SimpleMessenger.create_wakeup('trejkaz@trypticon.org')
    
    # Test delivery.
    SimpleMessenger.send_wakeup('trejkaz@trypticon.org')
    assert_equal [ @expected ], @mock_messenger.deliveries
  end
end
