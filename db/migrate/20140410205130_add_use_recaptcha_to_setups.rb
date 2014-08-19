class AddUseRecaptchaToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :use_recaptcha, :boolean, default: false
  end
end
