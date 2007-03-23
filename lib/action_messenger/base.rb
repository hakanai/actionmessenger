module ActionMessenger
  class Base
    # The messages being built.
    attr_reader :messages
    
    # The name of the messenger to use.
    #
    # If set to nil, or if the messenger lookup returns nil, the message won't be sent,
    # which may be useful if you need a simple way to temporarily disable messaging.
    #
    # The default messenger is retrieved from the configuration, by looking up the
    # name of the current Rails environment.  If running outside of Rails, 'default'
    # is used as the default.
    attr_accessor :messenger
    
    class << self
      def method_missing(method_symbol, *parameters) #:nodoc:
        case method_symbol.id2name
        when /^create_([_a-z]\w*)/ then new($1, *parameters).messages
        when /^send_([_a-z]\w*)/   then new($1, *parameters).send_messages
        end
      end
      
      @@default_messenger = 'default'

      # Sets the messenger to use for this class.
      def uses_messenger(messenger)
        @@default_messenger = messenger
      end
      
      # Registers to receive messages.
      # When a new message comes in, it will be sent to the instance method called 'received'.
      def receives_messages
        Messenger.resolve(@@default_messenger).add_message_handler do |message|
          new.received(message)
        end
      end
    end
    
    def initialize(method_name = nil, *parameters) #:nodoc:
      create!(method_name, *parameters) if method_name
    end
    
    def create!(method_name, *parameters) #:nodoc:
      initialize_defaults
      send(method_name, *parameters)
      
      # TODO: Templates, ActionMailer-style.

      recipients.each do |recipient|
        message = Message.new
        message.to = recipient
        message.subject = subject
        message.body = body
        messages << message
      end
    end
    
    # Initialises default settings for this messenger.
    def initialize_defaults
      @messenger = @@default_messenger
      @messages = []
      @recipients = []
      @subject = nil
      @body = {}
    end
    
    # Sets the recipients of the message being sent.
    #
    # If multiple recipients are specified, they will generally be sent as multiple
    # messages.
    def recipients(recipients = nil)
      unless recipients.nil?
        if recipients.is_a?(Array)
          @recipients += recipients
        else
          @recipients << recipients.to_s
        end
      end
      @recipients
    end
    
    # Sets a recipient.  Purely for readability if your app never sends the
    # same message to multiple recipients.
    def recipient(recipient)
      recipients(recipient)
    end

    # Sets the subject of the message being built.
    def subject(subject = nil)
      unless subject.nil?
        @subject = subject
      end
      @subject
    end
    
    # The body of the message being built.
    def body(body = nil)
      unless body.nil?
        @body = body
      end
      @body
    end

    # Sends multiple messages.
    def send_messages(messages = @messages, messenger = @messenger)
      unless messenger.nil?
        messenger = Messenger.resolve(messenger)
        unless messenger.nil?
          messages.each do |message|
            messenger.send_message(message)
          end
        end
      end
    end
  end
end
