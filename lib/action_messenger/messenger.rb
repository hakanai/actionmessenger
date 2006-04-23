require 'xmpp4r'

module ActionMessenger
  
  # Represents a single instant messenger.
  #
  # The static methods can be used to access a repository of multiple messengers
  # loaded from a YAML config file.
  class Messenger
    
    # The YAML configuration file where config will be loaded from.
    cattr_accessor :config_file
    
    # Creates a new messenger from its config hash.
    #
    # Hash can contain:
    #    jid:      the Jabber ID of this messenger, with resource if you wish.
    #    password: the password for this messenger.
    def initialize(config_hash = {})
      @listeners = []
      
      # Sanity check the JID to ensure it has a resource, and add one ourselves if it doesn't.
      jid = config_hash['jid']
      jid += '/ActionMessenger' unless jid =~ /\//
      
      # TODO: Different strategies for staying online (come online only to send messages.)
      # TODO: Reconnection strategy.
      # TODO: Multiple mechanisms for sending messages, for Jabber backend swap-out,
      #       but also to unit test the sending code.
      @client = Jabber::Client.new(Jabber::JID.new(jid))
      
      @client.connect
      @client.auth(config_hash['password'])
    end
    
    # Sends a message.
    def send_message(message)
      to = message.to
      to = Jabber::JID.new(to) unless to.is_a?(Jabber::JID)
      jabber_message = Jabber::Message.new(to, message.body)
      jabber_message.subject = message.subject
      @client.send(jabber_message)
    end
    
    # Gets the messenger config, potentially loading it from the file.
    def self.config
      unless defined?(@@config)
        config_file = @@config_file || (RAILS_ROOT + "/config/messengers.yml")
        @@config = YAML.load_file(config_file)
      end
    end
    
    @@messengers = {}
    
    # Registers a messenger by name.  This will probably only be used from unit tests.
    def self.register(name, messenger)
      @@messengers[name] = messenger
    end
    
    # Finds a messenger by its name.
    def self.find_by_name(name)
      messenger = @@messengers[name]
      if messenger.nil?
        @@messengers[name] = Messenger.new(config[name])
      end
      messenger
    end
  end
end
