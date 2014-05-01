class ContactsController < ApplicationController
  def index
    @page = current_setup.pages.where(slug: 'contacts').first
    @contact = Contact.new
  end

  def create
    contact_email = current_setup.contact_email
    @page = current_setup.pages.where(slug: 'contacts').first

    @contact = current_setup.contacts.build(params[:contact])

    respond_to do |format|
      if check_recaptcha and @contact.save
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

  private

  def check_recaptcha
    return true unless current_setup.use_recaptcha
    if verify_recaptcha(private_key: ENV["RECAPTCHA_PRIVATE_KEY"])
      return true
    else
      flash[:error] = 'Recaptcha check failed, please try again.'
      return false
    end
  end
end