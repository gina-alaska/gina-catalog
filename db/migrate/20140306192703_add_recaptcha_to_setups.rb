class AddRecaptchaToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :recaptcha_public, :text
    add_column :setups, :recaptcha_private, :text
  end
end
