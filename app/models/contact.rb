class Contact < ActiveRecord::Base
  attr_accessible :email, :message, :name

  belongs_to :setups
  validates_presence_of :name, :email, :message
  validate :check_for_spam

  def check_for_spam
  	if spam?
  	  errors.add(:message, 'containes HTML, please remove before sending message.')
  	  return false
  	end
  end

  def spam?
  	context = {whitelist: HTML::Pipeline::SanitizationFilter::FULL}
  	pipeline = HTML::Pipeline.new([HTML::Pipeline::SanitizationFilter], context)
  	sanitized = pipeline.call(self.message)[:output].to_s
  	self.message != sanitized
  end
end
