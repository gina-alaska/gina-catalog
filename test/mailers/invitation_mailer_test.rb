require 'test_helper'

class InvitationMailerTest < ActionMailer::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "invite" do
    email = InvitationMailer.invite_email(invitations(:one)).deliver
    
    assert_not ActionMailer::Base.deliveries.empty?
    
    assert_equal ['support@gina.alaska.edu'], email.from
    assert_equal ['testing@test.com'], email.to
    assert_equal "[TEST] You have been invitied to join the Test Catalog", email.subject
    assert email.body.multipart?, "Email is not multipart (html and text)"
    assert_equal read_fixture('invite.text').join, get_message_part(email, /plain/).body.to_s
  end
  
  protected
  
  def get_message_part(mail, content_type)
    mail.body.parts.find { |p| p.content_type.match content_type }
  end
end
