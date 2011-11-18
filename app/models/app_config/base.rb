module AppConfig
  
  # The base of  configulation container.
  # The configulation file is created as a yml format of the name 'config/application.yml'. 
  # The concreteness class name is the root element name 
  # that is the camelized singular form.
  # == static methods
  # instance - return the instance (singleton object)
  # define_attributes  - define 
  class Base
    
    def initialize(properties)
      @properties = properties
#      self.class.define_attributes(self, properties)
      self
    end
    
    private 

    def new
    end
    
    module StaticMethods

      # define attributes
      # == parameters
      # * attributes - array of attribute names (symbols or string names),
      #                or hash of attributes(key -> attribute name, value => default value)
      def define_attributes(attributes)
        if attributes.respond_to?(:each_pair)
          attributes.each_pair do |attr,value|
            proc = Proc.new { @properties[attr.to_s] || value }
            define_method(attr.to_sym, proc)
          end
        else
          attributes.each do |attr|
            proc = Proc.new { @properties[attr.to_s] }
            define_method(attr.to_sym, proc)
          end
        end
      end

    # get the instance 
      def instance
        @instance ||= 
        Proc.new do
          begin
            properties = YAML.load_file(config_path)
          rescue  => ex
            logger.error "failed in reading yaml (#{config_path})"
            logger.error ex.message
            return nil
          end
          if properties.nil?
            logger.error "failed in reading yaml (#{config_path})"
            return nil
          end
          self.new(properties[element_root])
        end.call
      end

      # the file path of the configulation file.
      def config_path
        ::Rails.root.to_s + "/config/application.yml"
      end

      private

      #  the root element name.
      def element_root
        name.demodulize.underscore
      end

      # get the logger object
      def logger
        require 'logger'
        rails_env = unless ENV['RAILS_ENV'].blank? 
          ENV['RAILS_ENV']
        else
          "development"
        end
        Logger.new(::Rails.root.to_s + "/log/#{rails_env}.log")
      end
  
    end

    extend(StaticMethods)

  end
  
end
