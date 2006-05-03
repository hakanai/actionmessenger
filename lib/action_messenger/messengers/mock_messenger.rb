module ActionMessenger
  module Messengers
    # A mock subclass of Messenger for use in unit tests where a network connection
    # may not be present.
    class MockMessenger < ActionMessenger::Messenger

      # The list of deliveries.
      attr_accessor :deliveries
    
      # Constructs the mock messenger.
      def initialize
        super
        @deliveries = []
      end
    
      # Sends a message.  Really just adds it to the delivery list, for unit testing.
      def send_message(message)
        @deliveries << message
      end
      
      # Fakes a message being received, for unit testing.
      def fake_received(message)
        message_received(message)
      end
    end
  end
end
