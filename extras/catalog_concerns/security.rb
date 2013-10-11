module CatalogConcerns
  module Security
    extend ActiveSupport::Concern
    
    protected
  
    def authenticate_manager!
      unless user_is_a_member? and (current_member.access_catalog? or current_member.access_cms? or current_member.access_permissions?)
        authenticate_user!
      end      
    end
  
    def authenticate_access_catalog!
      unless user_is_a_member? and current_member.access_catalog?
        authenticate_user!
      end      
    end
  
    def authenticate_access_cms!
      unless user_is_a_member? and current_member.access_cms?
        authenticate_user!
      end      
    end
  
    def authenticate_access_permissions!
      unless user_is_a_member? and current_member.access_permissions?
        authenticate_user!
      end      
    end

    def authenticate_access_settings!
      unless user_is_a_member? and current_member.access_settings?
        authenticate_user!
      end      
    end  
  
    def authenticate_edit_records!
      unless user_is_a_member? and current_member.can_manage_catalog?
        authenticate_user!
      end
    end  
  
    def authenticate_publish_records!
      unless user_is_a_member? and current_member.can_publish_catalog?
        authenticate_user!
      end
    end
  end
end