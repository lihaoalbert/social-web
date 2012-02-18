class CreateUserkeys < ActiveRecord::Migration
  def change
    create_table :userkeys do |t|
      t.column :mail_user, :string, :limit => 100, :null => false
      t.column :weibo_firm, :string, :limit => 50, :null => false
      t.column :key1, :string, :limit => 50, :null => false
      t.column :key2, :string, :limit => 50, :null => false
      t.column :user_id, :integer, :limit => 10, :null => false
      t.timestamps
    end
  end
end
