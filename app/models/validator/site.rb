module Validator
  
  # = Validator::Site
  # Validates the site id
  class Site < ActiveModel::Validator
  
    TRANSLATION_SCOPE = [:errors, :messages]
  
    def validate(record)
      return false if record.site_id.nil?
      if ::Site.find_by_id(record.site_id).nil?
        record.errors[:base] << I18n.t(:site, 
                                      :scope => TRANSLATION_SCOPE)
      end
    end  

  end

end
