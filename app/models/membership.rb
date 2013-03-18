class Membership < ActiveRecord::Base
  attr_accessible :email, :setup, :user, :role_ids
  
  has_many :membership_roles, uniq: true
  has_many :roles, :through => :membership_roles
  has_many :permissions, :through => :roles do
    def has_any?(*perms)
      # if user is an admin they have access to everything!
      return true if proxy_association.owner.user.is_an_admin?
      where(name: perms).uniq.all.size > 0
    end
    
    def has_all?(*perms)
      # if user is an admin they have access to everything!
      return true if proxy_association.owner.user.is_an_admin?
      where(name: perms).uniq.all.size == perms.count      
    end
  end
  belongs_to :user, :primary_key => :email, :foreign_key => :email
  belongs_to :setup
  
  def method_missing(method_id, *args)
    if match = matches_dynamic_role_check?(method_id)
      return true if self.user.try(:is_an_admin?)
      
      tokenize_roles(match.captures.first).each do |check|
        return true if self.roles.index { |i| i.name == check }
      end
      return false
    elsif match = matches_dynamic_perm_check?(method_id)
      return true if self.user.try(:is_an_admin?)
      
      permission = permissions.where(name: match.captures.first).first
      return true if permission
      return false
    elsif match = matches_dynamic_perm_group_check?(method_id)
      return true if self.user.try(:is_an_admin?)
      
      permission = permissions.where(group: match.captures.first).first
      return true if permission
      return false
    else
      super
    end
  end
  
  private

  def matches_dynamic_perm_group_check?(method_id)
    /^access_([a-zA-Z]\w*)\?$/.match(method_id.to_s)
  end

  def matches_dynamic_perm_check?(method_id)
    /^can_([a-zA-Z]\w*)\?$/.match(method_id.to_s)
  end

  def matches_dynamic_role_check?(method_id)
    /^is_an?_([a-zA-Z]\w*)\?$/.match(method_id.to_s)
  end

  def tokenize_roles(string_to_split)
    string_to_split.split(/_or_/)
  end
end
