class ContactsController < ApplicationController
  protect_from_forgery :except => :create

  def create
    contact_email = @setup.contact_email

    contact = Contact.new(params[:contact])

    if @setup.contacts << contact
      respond_to do |format|
        format.html {
          ContactMailer.contact_email(contact_email, params[:contact]).deliver
          flash[:success] = 'Message Sent.'
          redirect_to root_path
        }
      end
    else
      respond_to do |format|
        flash[:failure] = 'Error: Message not sent!'
        redirect_to page_path("contact-us")
      end
    end
  end

end