module CatalogConcerns
  module SystemContent
    extend ActiveSupport::Concern
    
    included do
      before_save :verify_system_page_changes
    end
    
    def verify_system_page_changes
      if self.system_page? and self.slug_changed?
        self.errors.add(:slug, "can't be changed.  This slug is required by the application to work properly.")
        return false 
      end
    end
  end
end
