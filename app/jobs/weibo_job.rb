class WeiboJob
  @queue = :addfollow_queue2
  def self.perform(user_id)
#    puts "safaf goog"
     @userkey = Userkey.find(1)
     @txtkey1 = @userkey.key1
     @txtkey2 = @userkey.key2
     oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
     oauth.authorize_from_access(@txtkey1,@txtkey2)
     Weibo::Base.new(oauth).friendship_create(user_id)
  end


end