class FeedbackController < ApplicationController
  def create
    FeedbackMailer.comments_email(params[:comment], current_user).deliver

    respond_to do |format|
      format.json {
        render :json => {
          :success => true,
          :flash => [
            "Thank you, your feedback has been submitted.",
            "We appreciate your input and will follow up regarding your questions, concerns or comments as soon as we are able."
          ]
        }
      }
    end
  end
end
