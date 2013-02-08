class ContactsController < ApplicationController
  include Rack::Recaptcha::Helpers

  def index
    @page = Page.where(slug: 'contact-us').first
    @contact = Contact.new
  end

  def create
    contact_email = @setup.contact_email
    @page = Page.where(slug: 'contact-us').first

    @contact = @setup.contacts.build(params[:contact])

    respond_to do |format|
      if @contact.save
        format.html {
          ContactMailer.contact_email(contact_email, params[:contact]).deliver
          flash[:success] = 'Message Sent.'
          redirect_to root_path
        }
      else
        @contact.valid?
        format.html do
          render("index")
        end
      end
    end
  end

end