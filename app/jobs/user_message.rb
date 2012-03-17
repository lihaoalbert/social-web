class UserMessage
  @queue = :webo_jobs
  def self.perform
    @userkey = Userkey.find(:all)
    @userkey.each do |userkey|
      oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
      oauth.authorize_from_access(userkey.key1, userkey.key2)
      usermes = Weibo::Base.new(oauth).verify_credentials
      MonitorUser.create({
        :UID => usermes.id, 
        :screen_name => usermes.screen_name, 
        :name => usermes.name, 
        :province => usermes.province, 
        :city => usermes.city, 
        :location => usermes.location, 
        :url => usermes.url, 
        :profile_image_url => usermes.profile_image_url, 
        :domain => usermes.domain, 
        :gender => usermes.gender, 
        :created_user => usermes.created_user, 
        :geo_enabled => usermes.geo_enabled, 
        :followers_count => usermes.followers_count, 
        :friends_count => usermes.friends_count, 
        :statuses_count => usermes.statuses_count,  
        :favourites_count => usermes.favourites_count, 
        :user_id => userkey.user_id  
      })
    end
  end


end