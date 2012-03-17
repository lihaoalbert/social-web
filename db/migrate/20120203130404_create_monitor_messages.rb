class CreateMonitorMessages < ActiveRecord::Migration
  def change
    create_table :monitor_messages do |t|
      t.column :WID, :integer, :limit => 19, :null => false
      t.column :reposts_count, :integer, :limit => 19
      t.column :comments_count , :integer, :limit => 19
      t.timestamps
    end
  end
end
