module ActionMessenger
  
  # Represents a single instant messenger.
  class Messenger
    
    # The configuration used to load this messenger.
    attr_reader :config
    
    # Initialises the messenger.  At the moment this class doesn't do anything with the config
    # except store it into an attribute.
    def initialize(config_hash = {})
      @config = config_hash
      @message_handlers = []
    end
    
    # Adds a message handler which will be called for any incoming messages.
    def add_message_handler(&block)
      @message_handlers << block
    end
    
    # Called by subclasses when a message is received.
    def message_received(message)
      @message_handlers.each do |block|
        block.call(message)
      end
    end
    
    # Resolves any object into a Messenger.  If the object itself is a Messenger,
    # the object itself is returned.  Otherwise, it is converted to a string and that
    # string is used to look it up in the registry.
    def self.resolve(messenger)
      if messenger.is_a?(Messenger)
        messenger
      else
        MessengerRegistry.find_by_name(messenger.to_s)
      end
    end

    # Shuts down this messenger.
    #
    # This implementation does nothing and is here for the convenience of subclasses that
    # don't need special shutdown code.
    def shutdown
    end
  end
end
