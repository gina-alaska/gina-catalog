class Ability
  include CanCan::Ability

  def initialize(user, site)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    
    user ||= User.new
    
    if user.global_admin?
      can :manage, Site
      can :manage, User
      can :manage, EntryType      
    end
    
    if user.has_role?(:cms_manager, site)
      can :view_manager_menu, User
    end
    
    if user.has_role?(:data_manager, site)
      can :view_manager_menu, User
      
      can :manage, Agency
      can :manage, Contact
      can :manage, UseAgreement
      can :manage, Collection
      can :manage, Entry do |entry|
        entry.new_record? or entry.owner_site == site
      end
    end
    
    if user.has_role?(:site_manager, site)
      can :view_manager_menu, User
      
      can :manage, Permission do |permission|
        permission.new_record? or permission.site == site
      end
      can :manage, Invitation do |invitation|
        invitation.new_record? or invitation.site == site
      end
    end
        
  end
end
