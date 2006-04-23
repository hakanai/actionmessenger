require 'xmpp4r'

module ActionMessenger
  
  # Represents a single instant messenger.
  #
  # The static methods can be used to access a repository of multiple messengers
  # loaded from a YAML config file.
  class Messenger
    
    # The YAML configuration file where config will be loaded from.
    cattr_accessor :config_file
    
    # Gets the messenger config, potentially loading it from the file.
    def self.config
      unless defined?(@@config)
        config_file = @@config_file || (RAILS_ROOT + "/config/messenger.yml")
        @@config = YAML.load_file(config_file)
      end
    end
    
    @@messengers = {}
    
    # Registers a messenger by name.  This will probably only be used from unit tests.
    def self.register(name, messenger)
      @@messengers[name] = messenger
    end
    
    def self.create_from_config(config_hash)
      case config_hash['type']
        when 'mock'   then messenger = Messengers::MockMessenger.new
        when 'xmpp4r' then messenger = Messengers::Xmpp4rMessenger.new(config_hash)
        else raise ArgumentError, "Unknown messenger type: #{config_hash['type']}"
      end
      messenger
    end
    
    # Finds a messenger by its name.
    def self.find_by_name(name)
      messenger = @@messengers[name]
      if messenger.nil?
        @@messengers[name] = messenger = self.create_from_config(config[name])
      end
      messenger
    end
  end
end
