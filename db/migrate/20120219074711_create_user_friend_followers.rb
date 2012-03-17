class CreateUserFriendFollowers < ActiveRecord::Migration
  def change
    create_table :user_friend_followers do |t|
      t.column :UID, :integer, :limit => 19, :null => false                   #微博用户ID
      t.column :source_UID, :integer, :limit => 19, :null => false            #微博源用户ID
      t.column :follower_friend_UID, :integer, :limit => 19, :null => false   #源用户关注粉丝用户ID
      t.column :user_label, :string, :limit => 50, :null => false             #标注此ID是关注还是粉丝
      t.column :user_id, :integer, :null => false                             #本系统用户ID

      t.timestamps
    end
  end
end
