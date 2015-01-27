class InvitationMailer < ActionMailer::Base
  default from: "support@gina.alaska.edu"

  def invite_email(invitation)
    @invitation = invitation.reload
    @portal = @invitation.portal
    @url = accept_manager_invitation_url(@invitation, host: @portal.default_url.url)

    mail(to: @invitation.email, subject: "[#{@portal.acronym}] You have been invitied to join the #{@portal.title}")
  end
end
