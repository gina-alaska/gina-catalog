class AddSdsViewPermission < ActiveRecord::Migration
  PERM = {
    name: 'sds_view', group: 'sds', description: 'View SDS information'
    }

  def up
    Permission.create(PERM)
  end

  def down
    Permission.where(name: PERM[:name]).first.destroy
  end
end
