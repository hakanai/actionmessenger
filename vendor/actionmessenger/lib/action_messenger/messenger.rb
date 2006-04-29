module ActionMessenger
  
  # Represents a single instant messenger.
  #
  # TODO: See what utilities we can move into here, common to all messengers.
  class Messenger
    
    # The configuration used to load this messenger.
    attr_reader :config
    
    # Initialises the messenger.  At the moment this class doesn't do anything with the config
    # except store it into an attribute.
    def initialize(config_hash = {})
      @config = config_hash
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
  end
end
