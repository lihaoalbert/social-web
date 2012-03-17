class UserFollowerFriends
  @queue = :webo_jobs
  def self.perform
    @userkey = Userkey.find(:all)
    @userkey.each do |userkey|
      oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
      oauth.authorize_from_access(userkey.key1, userkey.key2)
      @userfriend = Weibo::Base.new(oauth).friend_ids({:count => 1, :count => 1})
      @userfollower = Weibo::Base.new(oauth).follower_ids({:count => 1, :count => 1})
      
      @userfriend.each do |userfriend|
        if userfriend[0] == "ids" then
          userfriend[1].each do |friendids|
            @number = UserFriendFollower.count_by_sql("select count(*) from user_friend_followers where UID='#{userkey.UID}' and source_UID='#{userkey.UID}' and follower_friend_UID='#{friendids}'")
            if @number == 0
              UserFriendFollower.create({
                :UID => userkey.UID, 
                :source_UID => userkey.UID, 
                :follower_friend_UID => friendids, 
                :user_label => "friend", 
                :user_id => userkey.user_id
              })
            end
            @usermessage = Weibo::Base.new(oauth).user_show({:user_id => friendids})
            @usernum = FriendFollower.count(:conditions => "UID = #{friendids}")
            if @usernum == 0 then
              FriendFollower.create({
                :UID => @usermessage.id, 
                :screen_name => @usermessage.screen_name, 
                :name => @usermessage.name, 
                :province => @usermessage.province, 
                :city => @usermessage.city, 
                :location => @usermessage.location, 
                :url => @usermessage.url, 
                :profile_image_url => @usermessage.profile_image_url, 
                :domain => @usermessage.domain, 
                :gender => @usermessage.gender, 
                :created_user => @usermessage.created_at, 
                :geo_enabled => @usermessage.geo_enabled,  
                :followers_count => @usermessage.followers_count, 
                :friends_count => @usermessage.friends_count, 
                :statuses_count => @usermessage.statuses_count, 
                :favourites_count => @usermessage.favourites_count, 
                :user_id => userkey.user_id, 
                :user_label => "friend"
              })
            end
            @userfriend1 = Weibo::Base.new(oauth).friend_ids({:user_id => friendids, :count => 1, :count => 1})
            @userfriend1.each do |userfriend1|
              if userfriend1[0] == "ids" then
                userfriend1[1].each do |friendids1|
                  @number1 = UserFriendFollower.count_by_sql("select count(*) from user_friend_followers where UID='#{userkey.UID}' and source_UID='#{friendids}' and follower_friend_UID='#{friendids1}'")
                  if @number1 == 0
                    UserFriendFollower.create({
                      :UID => userkey.UID, 
                      :source_UID => friendids, 
                      :follower_friend_UID => friendids1, 
                      :user_label => "friend", 
                      :user_id => userkey.user_id
                    })
                  end
                  @usermessage1 = Weibo::Base.new(oauth).user_show({:user_id => friendids1})
                  @usernum1 = FriendFollower.count(:conditions => "UID = #{friendids1}")
                  if @usernum1 == 0 then
                    FriendFollower.create({
                      :UID => @usermessage1.id, 
                      :screen_name => @usermessage1.screen_name, 
                      :name => @usermessage1.name, 
                      :province => @usermessage1.province, 
                      :city => @usermessage1.city, 
                      :location => @usermessage1.location, 
                      :url => @usermessage1.url, 
                      :profile_image_url => @usermessage1.profile_image_url, 
                      :domain => @usermessage1.domain, 
                      :gender => @usermessage1.gender, 
                      :created_user => @usermessage1.created_at, 
                      :geo_enabled => @usermessage1.geo_enabled,  
                      :followers_count => @usermessage1.followers_count, 
                      :friends_count => @usermessage1.friends_count, 
                      :statuses_count => @usermessage1.statuses_count, 
                      :favourites_count => @usermessage1.favourites_count, 
                      :user_id => userkey.user_id, 
                      :user_label => "friend"
                    })
                  end
                  @userfriend2 = Weibo::Base.new(oauth).friend_ids({:user_id => friendids1, :count => 1, :count => 1})
                  @userfriend2.each do |userfriend2|
                    if userfriend2[0] == "ids" then
                      userfriend2[1].each do |friendids2|
                        @number2 = UserFriendFollower.count_by_sql("select count(*) from user_friend_followers where UID='#{userkey.UID}' and source_UID='#{friendids1}' and follower_friend_UID='#{friendids2}'")
                        if @number2 == 0
                          UserFriendFollower.create({
                            :UID => userkey.UID, 
                            :source_UID => friendids1, 
                            :follower_friend_UID => friendids2, 
                            :user_label => "friend", 
                            :user_id => userkey.user_id
                          })
                        end
                        @usermessage2 = Weibo::Base.new(oauth).user_show({:user_id => friendids2})
                        @usernum2 = FriendFollower.count(:conditions => "UID = #{friendids2}")
                        if @usernum2 == 0 then
                          FriendFollower.create({
                            :UID => @usermessage2.id, 
                            :screen_name => @usermessage2.screen_name, 
                            :name => @usermessage2.name, 
                            :province => @usermessage2.province, 
                            :city => @usermessage2.city, 
                            :location => @usermessage2.location, 
                            :url => @usermessage2.url, 
                            :profile_image_url => @usermessage2.profile_image_url, 
                            :domain => @usermessage2.domain, 
                            :gender => @usermessage2.gender, 
                            :created_user => @usermessage2.created_at, 
                            :geo_enabled => @usermessage2.geo_enabled,  
                            :followers_count => @usermessage2.followers_count, 
                            :friends_count => @usermessage2.friends_count, 
                            :statuses_count => @usermessage2.statuses_count, 
                            :favourites_count => @usermessage2.favourites_count, 
                            :user_id => userkey.user_id, 
                            :user_label => "friend"
                          })
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      
      @userfollower.each do |userfollower|
        if userfollower[0] == "ids" then
          userfollower[1].each do |followerids|
            @number = UserFriendFollower.count_by_sql("select count(*) from user_friend_followers where UID='#{userkey.UID}' and source_UID='#{userkey.UID}' and follower_friend_UID='#{followerids}'")
            if @number == 0
              UserFriendFollower.create({
                :UID => userkey.UID, 
                :source_UID => userkey.UID, 
                :follower_friend_UID => followerids, 
                :user_label => "follower", 
                :user_id => userkey.user_id
              })
            end
            @usermessage = Weibo::Base.new(oauth).user_show({:user_id => followerids})
            @usernum = FriendFollower.count(:conditions => "UID = #{followerids}")
            if @usernum == 0 then
              FriendFollower.create({
                :UID => @usermessage.id, 
                :screen_name => @usermessage.screen_name, 
                :name => @usermessage.name, 
                :province => @usermessage.province, 
                :city => @usermessage.city, 
                :location => @usermessage.location, 
                :url => @usermessage.url, 
                :profile_image_url => @usermessage.profile_image_url, 
                :domain => @usermessage.domain, 
                :gender => @usermessage.gender, 
                :created_user => @usermessage.created_at, 
                :geo_enabled => @usermessage.geo_enabled,  
                :followers_count => @usermessage.followers_count, 
                :friends_count => @usermessage.friends_count, 
                :statuses_count => @usermessage.statuses_count, 
                :favourites_count => @usermessage.favourites_count, 
                :user_id => userkey.user_id, 
                :user_label => "follower"
              })
            end
            @userfollower1 = Weibo::Base.new(oauth).follower_ids({:user_id => followerids, :count => 1, :count => 1})
            @userfollower1.each do |userfollower1|
              if userfollower1[0] == "ids" then
                userfollower1[1].each do |followerids1|
                  @number1 = UserFriendFollower.count_by_sql("select count(*) from user_friend_followers where UID='#{userkey.UID}' and source_UID='#{followerids}' and follower_friend_UID='#{followerids1}'")
                  if @number1 == 0
                    UserFriendFollower.create({
                      :UID => userkey.UID, 
                      :source_UID => followerids, 
                      :follower_friend_UID => followerids1, 
                      :user_label => "follower", 
                      :user_id => userkey.user_id
                    })
                  end
                  @usermessage1 = Weibo::Base.new(oauth).user_show({:user_id => followerids1})
                  @usernum1 = FriendFollower.count(:conditions => "UID = #{followerids1}")
                  if @usernum1 == 0 then
                    FriendFollower.create({
                      :UID => @usermessage1.id, 
                      :screen_name => @usermessage1.screen_name, 
                      :name => @usermessage1.name, 
                      :province => @usermessage1.province, 
                      :city => @usermessage1.city, 
                      :location => @usermessage1.location, 
                      :url => @usermessage1.url, 
                      :profile_image_url => @usermessage1.profile_image_url, 
                      :domain => @usermessage1.domain, 
                      :gender => @usermessage1.gender, 
                      :created_user => @usermessage1.created_at, 
                      :geo_enabled => @usermessage1.geo_enabled,  
                      :followers_count => @usermessage1.followers_count, 
                      :friends_count => @usermessage1.friends_count, 
                      :statuses_count => @usermessage1.statuses_count, 
                      :favourites_count => @usermessage1.favourites_count, 
                      :user_id => userkey.user_id, 
                      :user_label => "follower"
                    })
                  end
                  @userfollower2 = Weibo::Base.new(oauth).follower_ids({:user_id => followerids1, :count => 1, :count => 1})
                  @userfollower2.each do |userfollower2|
                    if userfollower2[0] == "ids" then
                      userfollower2[1].each do |followerids2|
                        @number2 = UserFriendFollower.count_by_sql("select count(*) from user_friend_followers where UID='#{userkey.UID}' and source_UID='#{followerids1}' and follower_friend_UID='#{followerids2}'")
                        if @number2 == 0
                          UserFriendFollower.create({
                            :UID => userkey.UID, 
                            :source_UID => followerids1, 
                            :follower_friend_UID => followerids2, 
                            :user_label => "follower", 
                            :user_id => userkey.user_id
                          })
                        end
                        @usermessage2 = Weibo::Base.new(oauth).user_show({:user_id => followerids2})
                        @usernum2 = FriendFollower.count(:conditions => "UID = #{followerids2}")
                        if @usernum2 == 0 then
                          FriendFollower.create({
                            :UID => @usermessage2.id, 
                            :screen_name => @usermessage2.screen_name, 
                            :name => @usermessage2.name, 
                            :province => @usermessage2.province, 
                            :city => @usermessage2.city, 
                            :location => @usermessage2.location, 
                            :url => @usermessage2.url, 
                            :profile_image_url => @usermessage2.profile_image_url, 
                            :domain => @usermessage2.domain, 
                            :gender => @usermessage2.gender, 
                            :created_user => @usermessage2.created_at, 
                            :geo_enabled => @usermessage2.geo_enabled,  
                            :followers_count => @usermessage2.followers_count, 
                            :friends_count => @usermessage2.friends_count, 
                            :statuses_count => @usermessage2.statuses_count, 
                            :favourites_count => @usermessage2.favourites_count, 
                            :user_id => userkey.user_id, 
                            :user_label => "follower"
                          })
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      
    end
  end
end