class CreateUserInfos < ActiveRecord::Migration
  def change
    create_table :user_infos do |t|
      t.column :user_id, :integer, :limit => 10, :null => false
      t.column :nick_name, :string, :limit => 50, :null => false
      t.column :real_name, :string, :limit => 50
      t.column :province, :integer, :limit => 10
      t.column :city, :integer, :limit => 10
      t.column :gender, :integer, :limit => 10
      t.column :name_option, :integer, :limit => 10
      t.column :birthday_option, :integer, :limit => 10
      t.column :blog, :string, :limit => 100
      t.column :blog_option, :integer, :limit => 10
      t.column :email, :string, :limit => 100
      t.column :email_option, :integer, :limit => 10
      t.column :qq, :string, :limit => 100
      t.column :qq_option, :integer, :limit => 10
      t.column :msn, :string, :limit => 100
      t.column :msn_option, :integer, :limit => 10
      t.column :mydesc, :string, :limit => 255
      t.column :Date_Day, :integer, :limit => 10
      t.column :Data_Month, :integer, :limit => 10
      t.column :Data_Year, :integer, :limit => 10
      t.timestamps
    end
  end
end
