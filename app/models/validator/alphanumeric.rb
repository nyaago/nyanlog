module Validator
  
  # = Validator::Alphanumeric
  # Validates whether the value of the specified attribute is 
  # consisted of alphabetical characters and numeral characters
  class Alphanumeric < ActiveModel::Validator
  
    TRANSLATION_SCOPE = [:errors, :messages]
  
    def validate(record)
      unless record.send(options[:attribute]).to_s.match(/^[a-zA-Z]{1}[a-zA-Z0-9]{1,}$/)
        record.errors[:name] << I18n.t(:alphanumetic, 
                                      :scope => TRANSLATION_SCOPE)
      end
    end  

  end

end
