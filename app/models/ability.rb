class Ability
  include CanCan::Ability

  def initialize(user, current_portal, controller_namespace)
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

    can [:read, :map], Entry, &:published?
    cannot [:read, :map], Entry, published_at: nil

    can :read, Attachment
    can :read, :dashboard
    cannot :read, Attachment, category: 'Private Download'
    can :exports, Entry

    can :accept, Invitation unless user.new_record?

    can :view_admin, :menu if user.global_admin?

    can :view_cms, :menu if user.role?(:cms_manager, current_portal)

    if user.role?(:data_entry, current_portal) || user.role?(:data_manager, current_portal)
      can :view_catalog, :menu
    end

    if user.global_admin?
      can :manage, [User, EntryType, Region, DataType, IsoTopic]
    end

    if user.role?(:cms_manager, current_portal)
      can :manage, [Cms::Layout, Cms::Page, Cms::Snippet, Cms::Theme, Cms::Attachment], portal_id: current_portal.id
    end

    if user.role?(:data_entry, current_portal)
      can [:read, :preview], Attachment do |attachment|
        attachment.entry.new_record? || attachment.entry.owner_portal = current_portal
      end

      can :manage, [Organization, Contact, MapLayer]
      can :manage, [UseAgreement, Collection], portal_id: current_portal.id
      can [:read, :map, :read_unpublished], Entry do |entry|
        entry.new_record? || current_portal.self_and_ancestors.include?(entry.owner_portal)
      end
      can [:create, :update, :archive], Entry do |entry|
        entry.new_record? || entry.owner_portal == current_portal
      end
      can [:downloads, :links], :dashboard
    end

    if user.role?(:data_manager, current_portal)
      can [:read, :preview], Attachment do |attachment|
        attachment.entry.new_record? || attachment.entry.owner_portal = current_portal
      end

      can :manage, :tag
      can :manage, [Organization, Contact, MapLayer]
      can :manage, [UseAgreement, Collection], portal_id: current_portal.id

      can [:read, :map, :read_unpublished], Entry do |entry|
        entry.new_record? || current_portal.self_and_ancestors.include?(entry.owner_portal)
      end
      can [:create, :update, :destroy, :publish, :unpublish, :archive, :unarchive], Entry do |entry|
        entry.new_record? || entry.owner_portal == current_portal
      end
      can [:downloads, :links], :dashboard
    end

    if user.role?(:portal_manager, current_portal)
      can :manage, [Permission, Invitation], portal_id: current_portal.id
    end

    case controller_namespace
    when 'admin'
      can :manage, Portal if user.global_admin?
    else
      if user.role?(:portal_manager, current_portal)
        can [:read, :update], Portal, id: current_portal.id
      end
    end

    cannot :update, UseAgreement, &:archived?
  end
end
