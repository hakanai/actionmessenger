
module ActionMessenger
  class Base
    # The message being built, to later be sent.
    attr_accessor :message
    
    # The name of the messenger to use.
    #
    # If set to nil, or if the messenger lookup returns nil, the message won't be sent,
    # which may be useful if you need a simple way to temporarily disable messaging.
    #
    # The default messenger is retrieved from the configuration, by looking up the
    # name of the current Rails environment.  If running outside of Rails, 'default'
    # is used as the default.
    attr_accessor :messenger
    
    # The default messenger to use.
    cattr_accessor :default_messenger
    
    class << self
      def method_missing(method_symbol, *parameters)
        case method_symbol.id2name
        when /^create_([_a-z]\w*)/ then new($1, *parameters).message
        when /^send_([_a-z]\w*)/   then new($1, *parameters).send_message
        end
      end
    end
    
    def initialize(method_name = nil, *parameters)
      create!(method_name, *parameters) if method_name
    end
    
    def create!(method_name, *parameters)
      initialize_defaults
      send(method_name, *parameters)
      
      # TODO: Templates, ActionMailer-style.
    end
    
    # Initialises default settings for this messenger.
    def initialize_defaults
      @messenger = @@default_messenger || RAILS_ENV || 'default'
      @message = Message.new
    end
    
    # Sends the message
    def send_message(message = @message, messenger = @messenger)
      unless messenger.nil?
        messenger = Messenger.find_by_name(messenger.to_s)
        unless messenger.nil?
          messenger.send_message(message)
        end
      end
    end
  end
end
