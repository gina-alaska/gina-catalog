class Ability
  include CanCan::Ability

  def initialize(user, portal, _controller_namespace)
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    @portal = portal
    user ||= User.new
    @user = user

    setup_global_permissions
    setup_global_admin_permissions
    setup_portal_permissions
  end

  def current_portal
    @portal
  end

  def current_user
    @user
  end

  def setup_global_permissions
    can %i[read map], Entry, &:published?
    cannot %i[read map], Entry, published_at: nil

    can :read, Attachment
    cannot :read, Attachment, category: 'Private Download'
    can :exports, Entry
    can :accept, Invitation unless current_user.new_record?
  end

  def setup_portal_permissions
    setup_cms_manager_permissions     if current_user.role?(:cms_manager, current_portal)
    setup_data_entry_permissions      if current_user.role?(:data_manager, current_portal) || current_user.role?(:data_entry, current_portal)
    setup_data_manager_permissions    if current_user.role?(:data_manager, current_portal)
    setup_portal_manager_permissions  if current_user.role?(:portal_manager, current_portal)
  end

  def setup_global_admin_permissions
    return unless current_user.global_admin?
    can :view_admin, :menu
    can :manage, [User, EntryType, Region, DataType, IsoTopic, Portal]
  end

  def setup_portal_manager_permissions
    can :view_portal, :menu
    can :manage, [Permission, Invitation], portal_id: current_portal.id
    can %i[read update], Portal, id: current_portal.id
  end

  def setup_cms_manager_permissions
    can :view_cms, :menu
    can :read, :dashboard
    can :manage, [Cms::Layout, Cms::Page, Cms::Snippet, Cms::Theme, Cms::Attachment], portal_id: current_portal.id
  end

  def setup_data_entry_permissions
    can :view_catalog, :menu

    can %i[read preview], Attachment do |attachment|
      attachment.entry.new_record? || attachment.entry.owner_portal = current_portal
    end

    can :manage, [Organization, Contact, MapLayer]
    can :manage, [UseAgreement, Collection], portal_id: current_portal.id
    cannot :update, UseAgreement, &:archived?

    can %i[read map read_unpublished], Entry do |entry|
      entry.new_record? || current_portal.self_and_ancestors.include?(entry.owner_portal)
    end
    can %i[create update archive], Entry do |entry|
      entry.new_record? || entry.owner_portal == current_portal
    end
    can %i[downloads links], :dashboard
  end

  def setup_data_manager_permissions
    can :manage, :tag
    can %i[destroy publish unpublish unarchive], Entry do |entry|
      entry.new_record? || entry.owner_portal == current_portal
    end
  end
end
