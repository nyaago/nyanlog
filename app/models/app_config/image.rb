module AppConfig
  
  # configulations about the image
  # * the configulation file path is the <appklication>/config/application.yml
  # * the base element name is the 'application'
  # == elementns
  # * path - the path which stores images
  # * resize_medium - value of the image magick option for resizing.
  # * resize_small - value of the image magick option for resizing.
  # * resize_thumb - value of the image magick option for resizing.
  class Image < Base

    # 
    INT_ATTRIBUTES = []
    
    define_attributes(INT_ATTRIBUTES)

    INT_ATTRIBUTES.each do |name|
      proc = Proc.new { send("#{name.to_s}_without_conv".to_sym).to_i }
      define_method "#{name.to_s}_with_conv".to_sym, proc
      alias_method_chain name, :conv
    end

    
    # 
    FLOAT_ATTRIBUTES = []
    
    define_attributes(FLOAT_ATTRIBUTES)
    
    FLOAT_ATTRIBUTES.each do |name|
      proc = Proc.new { send("#{name.to_s}_without_conv".to_sym).to_f }
      define_method "#{name.to_s}_with_conv".to_sym, proc
      alias_method_chain name, :conv
    end

    # 
    STRING_ATTRIBUTES = {:path => "~/tmp", 
                        :resize_medium => "250x250>", 
                        :resize_small => "160x160>", 
                        :resize_thumb => "100x100#"}
    
    define_attributes(STRING_ATTRIBUTES)
    
    
  end
  
end