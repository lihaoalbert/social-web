class CreateDisplayMessages < ActiveRecord::Migration
  def change
    create_table :display_messages do |t|
      t.column :WID, :integer, :limit => 19, :null => false
      t.column :wtext, :string, :limit => 255
      t.column :created_w, :datetime
      t.column :source, :string, :limit => 100
      t.column :user_id, :integer, :null => false
      t.column :wuser_id, :integer, :limit => 19
      t.column :screen_name, :string, :limit => 100
      t.column :user_name, :string, :limit => 100
      t.column :user_location, :string, :limit => 100
      t.column :profile_image_url, :string, :limit => 100
      t.column :monitor, :boolean, :limit => 3
      t.column :rule_id, :integer
      t.column :rulekeyword, :string, :limit => 255 
      t.timestamps
    end
    add_index :display_messages, :WID,                :unique => true
    add_index :display_messages, :rule_id,            :unique => true
  end
end
