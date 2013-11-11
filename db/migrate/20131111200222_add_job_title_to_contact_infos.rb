class AddJobTitleToContactInfos < ActiveRecord::Migration
  def change
    add_column :contact_infos, :job_title, :string
  end
end
