class CreateApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :applications do |t|
      t.string :token, null: false
      t.integer :chats_count, default: 0
      t.string :name, null: false
      t.timestamps
    end

    add_index :applications, :token, unique: true
  end
end
