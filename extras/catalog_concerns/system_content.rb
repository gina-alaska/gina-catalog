module CatalogConcerns
  module SystemContent
    extend ActiveSupport::Concern
    
    included do
      before_save :verify_system_page_changes
      before_destroy :prevent_system_delete
    end
    
    def verify_system_page_changes
      if self.system_page? and self.slug_changed?
        self.errors.add(:slug, "can't be changed.  This slug is required by the application to work properly.")
        return false 
      end
    end
    
    def prevent_system_delete
      self.errors.add(:base, "System items can't be deleted")
      !self.system_page?
    end
  end
end
