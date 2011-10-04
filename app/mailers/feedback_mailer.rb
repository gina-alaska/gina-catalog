class FeedbackMailer < ActionMailer::Base
  default from: "webmaster@gina.alaska.edu"

  def comments_email(comment, user = nil)
    @comment = comment
    @user = user
    mail(:to => "nssi@gina.alaska.edu", :subject => "[NSSI::Catalog] User Feedback Submission")
  end
end
