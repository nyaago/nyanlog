module AppConfig
  
  # application configulations
  # * the configulation file path is the <appklication>/config/application.yml
  # * the base element name is the 'application'
  # == elementns
  # * 
  class Application < Base

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
    STRING_ATTRIBUTES = {:send_file_method => "x_sendfile"}
    
    define_attributes(STRING_ATTRIBUTES)
    
    
    
  end
  
end