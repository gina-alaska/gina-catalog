require 'digest/sha1'

class User < ActiveRecord::Base
  has_many :user_roles
  has_many :roles, :through => :user_roles

  include Authentication
  include Authentication::ByCookieToken

  validates :email, :presence   => true,
                    :uniqueness => true,
                    :format     => { :with => Authentication.email_regex, :message => Authentication.bad_email_message },
                    :length     => { :within => 6..100 }

  validates :identity_url,
                    :presence   => true,
                    :uniqueness => true

  scope :real, lambda {
    where('email != ?', 'guest@gina.alaska.edu')
  }
  
  searchable do
    text :first_name
    text :last_name
    text :email
    
    integer :id
  end

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  #attr_accessor :mobile_pin_request
  
  attr_accessible :email, :fullname, :identity_url?, :note_attributes
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  # uff.  this is really an authorization, not authentication routine.
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  def self.guest
    where('identity_url = ?', 'Guest').first
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

    self.roles.delete(Role.where(:name => 'verified_user'))
  end

  def method_missing(method_id, *args)
    if match = matches_dynamic_role_check?(method_id)
      tokenize_roles(match.captures.first).each do |check|
        return true if self.roles.index { |i| i.name == check }
      end
      return false
=begin
    # No permission systems implemented yet
    elsif match = matches_dynamic_perm_check?(method_id)
      permission = Permission.find_by_name(match.captures.first)
      return true if permission and permissions.include? permission
      return false
=end
    else
      super
    end
  end

  def as_json(options = {})
    options[:only] ||= []
    options[:only] += [:id, :first_name, :last_name, :email, :identity_url]

    options[:methods] ||= []
    options[:methods] << :admin?
    options[:methods] << :authorized?
    options[:methods] << :fullname
    super(options)
  end

  private

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
