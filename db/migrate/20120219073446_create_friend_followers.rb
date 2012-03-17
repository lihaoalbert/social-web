class CreateFriendFollowers < ActiveRecord::Migration
  def change
    create_table :friend_followers do |t|
      t.column :UID, :integer, :limit => 19, :null => false                    #微博用户ID
      t.column :screen_name, :string, :limit => 50                             #用户昵称
      t.column :name, :string, :limit => 50                                    #友好显示名称
      t.column :province, :integer                                             #用户所在地区ID
      t.column :city, :integer                                                 #用户所在城市ID
      t.column :location, :string, :limit => 50                                #用户所在地
      t.column :url, :string, :limit => 50                                     #用户博客地址
      t.column :profile_image_url, :string, :limit => 100                      #用户头像地址
      t.column :domain, :string, :limit => 50                                  #用户的个性化域名
      t.column :gender, :string, :limit => 50                                  #性别
      t.column :created_user, :datetime                                        #创建时间
      t.column :geo_enabled, :string, :limit => 10                             #是否允许带有地理信息
      t.column :followers_count, :integer                                      #粉丝数
      t.column :friends_count, :integer                                        #关注数
      t.column :statuses_count, :integer                                       #微博数
      t.column :favourites_count, :integer                                     #收藏数
      t.column :user_id, :integer, :null => false                              #已有用户ID
      t.column :user_label, :string, :limit => 50                              #标注是粉丝还是关注

      t.timestamps
    end
  end
end
