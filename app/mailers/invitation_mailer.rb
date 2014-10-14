class InvitationMailer < ActionMailer::Base
  default from: "support@gina.alaska.edu"
  
  def invite_email(invitation)
    @invitation = invitation.reload
    @site = @invitation.site
    @url = accept_manager_invitation_url(@invitation, host: @site.default_url.url)
    
    mail(to: @invitation.email, subject: "[#{@site.acronym}] You have been invitied to join the #{@site.title}")
  end
end
