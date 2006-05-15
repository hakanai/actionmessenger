module ActionMessenger

  # A repository of preconfigured messengers loaded from YAML configuration.
  class MessengerRegistry
    # Exception thrown when the name of a messenger doesn't exist in the registry.
    class NoSuchMessengerError < ArgumentError
    end
    
    # Exception thrown when the config file cannot be found.
    class NoConfigFileError < IOError
    end
    
    # Exception thrown when the config exists but the type of messenger it specifies doesn't exist.
    class NoSuchMessengerTypeError < ArgumentError
    end
  
    # Set this to always return mocks.  Set by default when running in Rails testing mode.
    attr_accessor :mock_messengers
    
    # The config file.  Can be set before anything else is called to override the location
    # which configuration is loaded from.  Setting it after the configuration is already
    # loaded will have no effect.
    attr_accessor :config_file
    
    # All currently-active messengers.
    attr_reader :messengers

    # Trickery... we'll make unknown static method calls redirect to a shared instance.
    class << self
      @shared_instance = nil
      def method_missing(method, *params, &block) #:nodoc:
        if @shared_instance.nil?
          @shared_instance = MessengerRegistry.new
        end
        @shared_instance.send(method, *params, &block)
      end
      
      # Purely for the sake of unit testing.
      attr_accessor :shared_instance
    end
    
    # Constructs a new registry.
    def initialize
      @config_file = if defined?(RAILS_ROOT)
                       RAILS_ROOT + "/config/messenger.yml"
                     else
                       "messenger.yml"
                     end
                     
      @config = nil
      @messengers = {}
      @mock_messengers = (defined?(RAILS_ENV) and RAILS_ENV == 'test')
    end
    
    # Gets the messenger config.
    #
    # If the config hasn't been initialised already, then the config is loaded from
    # a file.
    def config
      if @config.nil?
        load_config
      end
      @config
    end
    
    # Adds extra configuration in hash form.
    def add_config(config_hashes)
      if @config.nil?
        @config = {}
      end
      @config.merge!(config_hashes)
    end
    
    # Loads (potentially additional) config from the given filename.
    def load_config(config_file = @config_file)
      unless File.exists?(config_file)
        raise NoConfigFileError, "Config file doesn't exist: #{config_file}"
      end
      add_config(YAML.load_file(config_file))
    end
    
    # Registers a messenger by name.  This will probably only be used from unit tests.
    def register(name, messenger)
      messengers[name.to_s] = messenger
    end
    
    # Creates a messenger from its configuration hash.
    def create_from_config(config_hash)
      if mock_messengers
        Messengers::MockMessenger.new
      else
        case config_hash['type']
          when 'mock' then Messengers::MockMessenger.new
          when 'xmpp4r' then Messengers::Xmpp4rMessenger.new(config_hash)
          else raise NoSuchMessengerTypeError, "Unknown messenger type: #{config_hash['type']}"
        end
      end
    end
    
    # Finds a messenger by its name.  Creates the messenger on-demand if the messenger
    # hasn't been initialised yet.
    def find_by_name(name)
      name = name.to_s
      messenger = messengers[name]
      if messenger.nil?
        config_hash = config[name]
        if config_hash.nil?
          raise NoSuchMessengerError, "No configuration for name #{name}"
        end
        messengers[name] = messenger = create_from_config(config_hash)
      end
      messenger
    end
  end
end
