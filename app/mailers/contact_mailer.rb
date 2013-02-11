class ContactMailer < ActionMailer::Base
  default from: "webmaster@gina.alaska.edu"

  def contact_email(contact_mail, contact)
    @comment = contact
    mail(:to => contact_mail, :subject => "[GINA::Catalog] User Contact Submission") do |format|
      format.html { render :layout => false }
    end
  end
end
