class AddLockVersionToApplications < ActiveRecord::Migration[8.0]
  def change
    add_column :applications, :lock_version, :integer, default: 0, null: false
  end
end
