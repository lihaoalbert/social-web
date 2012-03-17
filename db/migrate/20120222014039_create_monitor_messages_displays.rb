class CreateMonitorMessagesDisplays < ActiveRecord::Migration
  def change
    create_table :monitor_messages_displays do |t|
      t.column :WID, :integer, :limit => 19, :null => false
      t.column :reposts_count, :integer, :limit => 19
      t.column :comments_count , :integer, :limit => 19
      
      t.timestamps
    end
  end
end
