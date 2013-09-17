class AddSettingsPermision < ActiveRecord::Migration
  PERM = {
    name: 'settings', group: 'settings', description: 'Edit portal settings'
    }

  def up
    Permission.create(PERM)
  end

  def down
    Permission.where(name: PERM[:name]).first.destroy
  end
end
