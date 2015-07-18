class Ability
  include CanCan::Ability

  def initialize(user, current_portal)
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

    can :read, Entry

    unless user.new_record?
      can :accept, Invitation
    end

    if user.role?(:cms_manager, current_portal)
      can :view_catalog_menu, User
    end

    if user.role?(:data_manager, current_portal)
      can :view_catalog_menu, User

      can :manage, [Organization, Contact, MapLayer]
      can :read, Attachment
      can :manage, [UseAgreement, Collection],  portal_id: current_portal.id
      can [:manage, :archive], Entry do |entry|
        entry.new_record? || entry.owner_portal == current_portal
      end
      cannot :update, UseAgreement do |use_agreement|
        use_agreement.archived?
      end
    end

    if user.role?(:portal_manager, current_portal)
      can :view_portal_menu, User
      can [:read, :update], Portal,  id: current_portal.id
      can :manage, [Permission, Invitation],  portal_id: current_portal.id
    end

    if user.global_admin?
      can :view_admin_menu, User
      can :manage, [Portal, User, EntryType, Region, DataType, IsoTopic]
    end
  end
end
