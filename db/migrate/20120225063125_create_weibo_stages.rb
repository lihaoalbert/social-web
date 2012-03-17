class CreateWeiboStages < ActiveRecord::Migration
  def change
    create_table :weibo_stages do |t|
      t.column :WeiboID, :string, :limit => 30, :null => false
      t.column :WeiboText, :string, :limit => 200
      t.column :WeiboTime, :datetime
      t.column :WeiboSource, :string, :limit => 100
      t.column :WeiboUID, :string, :limit => 30
      t.column :ScreenName, :string, :limit => 30
      t.column :Province, :string, :limit => 20
      t.column :City, :string, :limit => 20
      t.column :UserLocation, :string, :limit => 30
      t.column :Profile_image_url, :string, :limit => 100
      t.column :Gender, :string, :limit => 3
      t.column :Followers_count, :integer
      t.column :Friends_count, :integer
      t.column :Statuses_count, :integer
      t.column :Verified, :boolean
      t.column :RetweetedID, :string, :limit => 30
      t.column :RuleID, :integer
      t.column :AccountID, :integer
      t.column :WeiboFrom, :string, :limit => 10
      
      t.timestamps
    end
  end
end
