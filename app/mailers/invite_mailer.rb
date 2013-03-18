class InviteMailer < ActionMailer::Base
  default from: "webmaster@gina.alaska.edu"

  def invite_email(default, email, title, user_email, add_text, url)
    @default = default
    @add_text = add_text
    @url = url
    mail(from: email, to: user_email, subject: "Welcome to the #{title} site.")
  end
end
