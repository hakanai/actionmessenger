module ActionMessenger
  module Messengers
    # A mock subclass of Messenger for use in unit tests where a network connection
    # may not be present.
    class MockMessenger < ActionMessenger::Messenger

      # The list of deliveries.
      attr_accessor :deliveries
    
      def initialize
        @deliveries = []
      end
    
      def send_message(message)
        @deliveries << message
      end
      
      def shutdown
      end
    end
  end
end
