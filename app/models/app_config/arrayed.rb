module AppConfig
  
  # The base of  arrayed configulation container.
  # The configulation file is created as a yml format of the name 'config/application.yml'. 
  # The concreteness class name is the root element name 
  # that is the camelized singular form.
  # == static methods
  # instance - return the instance (singleton object)
  # define_attributes  - define 
  class Arrayed
    
    def initialize
      self
    end
    
    private 

    def new
    end
    
    # 
    module ArrayMethods
    
      # 
      def find_by_name(name)
        return nil if self.size == 0
        model = self[0].class.new(name)
        if self.include?(model)
          self[self.find_index(model)]
        else
          nil
        end
      end

      # defaultの要素を返す
      def find_default
        return nil if self.size == 0
        model = self[0].class.new('default')
        if self.include?(model)
          self[self.find_index(model)]
        else
          self[0]
        end
      end

    end # ArrayMethods
    
    
    module StaticMethods

      @models = nil

      # Returns the array of models
      def array
        @models ||= load
      end
      
      protected
      
      # Returns the path of the configulation file
      def config_path
        ::Rails.root.to_s + "/config/#{self.name.split('::').last.underscore.pluralize}.yml"
      end


      # Returns the root element name.
      def element_root
        name.demodulize.underscore.pluralize
      end

      private

      # load the yml format file
      # Returns the arrayed models for every language (indexed by the locale).
      # 
      def load
        @models = []

        # 
        files = 
        if File.directory?(config_path) 
          files_in_dir = []
          Dir[config_path + "/*.yml"].each do |file|
            files_in_dir << file
          end
          files_in_dir
        elsif File.file?(config_path)
          [config_path]
        else
          nil
        end

        return nil if files.nil?

        # 
        @models = files.inject(@models) do |models, file|
          begin
            yaml = YAML.load_file(file)
          rescue  => ex
            logger.debug "failed in reading yaml (#{file})"
            next
          end
          if yaml.nil?
            logger.debug "failed in reading yaml (#{file})"
            next
          end
          models + yaml2models(yaml)
        end.extend(ArrayMethods)
      end


      # 
      def yaml2models(yaml)
        
        return [] if yaml[element_root].nil?

        if yaml[element_root].respond_to?(:each_with_index)
          yaml[element_root].collect do |elem|
            model = map_to_model(elem)
          end.delete_if {|elem| elem.nil? }
        elsif yaml[element_root].respond_to?(:each_key)
          model = map_to_model(yaml[element_root])
          if model.nil?
            []
          else
            [model]
          end
        else
          []
        end
      end

      def map_to_model(map)
        model = self.new

        map.each_pair do |key, value|
          if model.respond_to?("#{key}=".to_sym)
            model.send("#{key}=".to_sym, value)
          end
        end
        
        model                  
      end

      # 
      def logger
        require 'logger'
        rails_env = unless ENV['RAILS_ENV'].blank? 
          ENV['RAILS_ENV']
        else
          "development"
        end
        Logger.new(::Rails.root.to_s + "/log/#{rails_env}.log")
      end

    end # StaticMethods
    
    extend(StaticMethods)
      
  
  
  end
  
end
