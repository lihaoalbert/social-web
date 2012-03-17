class CreateUsernameSelects < ActiveRecord::Migration
  def change
    create_table :username_selects do |t|
      t.column :UID, :integer, :limit => 19, :null => false
      t.column :screen_name, :string, :limit => 50
      t.column :name, :string, :limit => 50
      t.column :province, :integer
      t.column :city, :integer
      t.column :location, :string, :limit => 50
      t.column :url, :string, :limit => 50
      t.column :profile_image_url, :string, :limit => 100
      t.column :domain, :string, :limit => 50
      t.column :gender, :string, :limit => 50
      t.column :created_user, :datetime
      t.column :geo_enabled, :string, :limit => 10
      t.column :followers_count, :integer
      t.column :friends_count, :integer
      t.column :statuses_count, :integer
      t.column :favourites_count, :integer
      t.column :user_id, :integer, :null => false
      t.column :rule_id, :integer
      t.column :rulename, :string, :limit => 100
      t.timestamps
    end
    add_index :username_selects, :UID,                :unique => true
    add_index :username_selects, :rule_id,            :unique => true
  end
end
