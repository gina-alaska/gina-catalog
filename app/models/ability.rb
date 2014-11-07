class Ability
  include CanCan::Ability

  def initialize(user, portal)
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
      can :manage, Portal
      can :manage, User
      can :manage, EntryType      
    end

    if user.has_role?(:cms_manager, portal)
      can :view_manager_menu, User
    end

    if user.has_role?(:data_manager, portal)
      can :view_manager_menu, User
      
      can :manage, Agency
      can :manage, Contact
      can :manage, UseAgreement
      can :manage, Collection
      can :manage, Entry do |entry|
        entry.new_record? or entry.owner_portal == portal
      end
    end    

    if user.has_role?(:portal_manager, portal)
      can :view_manager_menu, User
      
      can :manage, Permission do |permission|
        permission.new_record? or permission.portal == portal
      end
      can :manage, Invitation do |invitation|
        invitation.new_record? or invitation.portal == portal
      end
    end
           
  end
end
