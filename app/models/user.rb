require 'digest/sha1'

class User < ActiveRecord::Base
  has_many :user_roles
  has_many :roles, :through => :user_roles
  has_many :permissions, :through => :roles
  has_many :services
  has_many :memberships, :primary_key => :email, :foreign_key => :email 
  
  belongs_to :agency

  validates :email, :presence   => true,
                    :uniqueness => true,
                    :length     => { :within => 6..100 }

  scope :real, lambda {
    where('email != ?', 'guest@gina.alaska.edu')
  }
  
  searchable do
    text :first_name
    text :last_name
    text :email do 
      self.email.gsub('@', ' ')
    end
    text :roles do 
      self.roles.map(&:name)
    end
    
    string :last_name    
    integer :id
  end

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  #attr_accessor :mobile_pin_request
  
  attr_accessible :email, :fullname

  
  def self.guest
    where('email = ?', 'guest@gina.alaska.edu').first
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def fullname=(value)
    first, last = value.split(' ')
    write_attribute :first_name, first
    write_attribute :last_name, last
  end

  def fullname
    "#{first_name} #{last_name}"
  end

  def admin?
    self.is_an_admin?
  end

  def guest?
    self.id.nil?
  end

  def authorized?
    self.is_an_admin? || self.is_a_verified_user?
  end

  def authorize
    return false if self.is_an_admin? || self.authorized?
    self.roles << Role.where(:name => 'verified_user')
  end

  def unauthorize
    return false if self.is_an_admin? or !self.authorized?
    self.roles.destroy(Role.where(:name => 'verified_user'))
  end

  def method_missing(method_id, *args)
    if match = matches_dynamic_role_check?(method_id)
      tokenize_roles(match.captures.first).each do |check|
        return true if self.roles.index { |i| i.name == check }
      end
      return false
    elsif match = matches_dynamic_perm_check?(method_id)
      permission = Permission.where(name: match.captures.first).first
      return true if permission and permissions.include? permission
      return false
    elsif match = matches_dynamic_perm_group_check?(method_id)
      permission = Permission.where(group: match.captures.first).first
      return true if permission
      return false
    else
      super
    end
  end

  def as_json(options = {})
    {
      :id => self.id,
      :first_name => self.first_name,
      :last_name => self.last_name,
      :email => self.email,
      :identity_url => self.identity_url,
      :roles => self.roles.map(&:name),
      :fullname => self.fullname
    }
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
