module Design
  
  class Theme
    
    attr_reader :name, :path, :url
    
    module ArrayMethods
      def find_by_name(name)
        a = Design::Theme.array
        index = a.index do |x| 
          x.name == name 
        end
        if index
          a[index]
        else
          nil
        end
      end
    end
    
    public
    
    # Returns Design::Theme records
    def self.array
      @@array =
      Dir.open("#{::Rails.root.to_s}#{File::SEPARATOR}#{self.root_directory}") do |root|
        root.entries.delete_if do |f| 
          f == '..' || f == '.'  || 
          !File.directory?("#{root.path}#{File::SEPARATOR}#{f}")
        end.
        collect do |f|
          Design::Theme.new("#{root.path}#{File::SEPARATOR}#{f}")
        end.extend(ArrayMethods)
      end
    end

    def human_name
      self.name
    end

    # Returns the stylesheet path.
    def stylesheet_path
      files = Dir.glob("#{@path}#{File::SEPARATOR}*.css") 
      if files.size > 0
        files[0]
      else
        nil
      end
    end
    
    # Returns the stylesheet url.
    def stylesheet_url
      if path = stylesheet_path 
        url + File::SEPARATOR + path.split(File::SEPARATOR).last
      else
        nil
      end
    end

    # Returns the thumbnail path.
    def thumb_path
      ["jpg", "png","gif"].each do |ext|
        files = Dir.glob("#{@path}#{File::SEPARATOR}*.#{ext}") 
        if files.size > 0
          return files[0]
        else
          nil
        end
      end && nil
    end
    
    # Returns the thumbnail urk.
    def thumb_url
      if path = thumb_path 
        url + File::SEPARATOR + path.split(File::SEPARATOR).last
      else
        nil
      end
    end
    
    def ==(other)
      self.name == other.name
    end
    
    private

    def initialize(path)
      @path = path
      @name = @path.split(File::SEPARATOR).last
      @url = File::SEPARATOR + self.class.root_directory.split(File::SEPARATOR).last + 
            File::SEPARATOR +  @path.split(File::SEPARATOR).last
    end
    
    def self.root_directory
      "public#{File::SEPARATOR}themes"
    end
    
  end
  
end