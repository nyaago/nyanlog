module Validator
  
  # = Validator::Folder
  # Validates the folder id
  class Folder < ActiveModel::Validator
  
    TRANSLATION_SCOPE = [:errors, :messages]
  
    def validate(record)
      return false if record.folder_id.nil?
      if record.respond_to?(:site)
        if record.site.nil? || record.site.folders.nil?
          record.errors[:base] << I18n.t(:folder, 
                                        :scope => TRANSLATION_SCOPE)
        end
      else
        if ::Folder.find_by_id(record.folder_id).nil?
          record.errors[:base] << I18n.t(:folder, 
                                        :scope => TRANSLATION_SCOPE)
        end
      end
    end  
  end

end
