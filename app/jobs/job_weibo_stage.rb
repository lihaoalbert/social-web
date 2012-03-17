class JobWeiboStage
  @queue = :webo_jobs
  def self.perform(rule_accountid,rule_id,keyword,filterori,argsvalue,jobargs_id)
    @userkey = Userkey.find(rule_accountid)
        
    @strkeyword = keyword
    @filter_ori = filterori
    @starttime = argsvalue.to_i
    begin
      for i in (1...1440)      
        @endtime = argsvalue.to_i+60*i
        oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
        oauth.authorize_from_access(@userkey.key1, @userkey.key2)
        @messageselect=Weibo::Base.new(oauth).status_search(@strkeyword,{:starttime => @starttime, :endtime => @endtime, :filter_ori => @filter_ori })
        
        if @messageselect != "" && @messageselect != nil  then
          @messageselect.each do |f|
            WeiboStage.create({
              :WeiboID => f.id.to_s, 
              :WeiboText => f.text,
              :WeiboTime => f.created_at, 
              :WeiboSource => f.source, 
              :WeiboUID => f.user.id, 
              :ScreenName => f.user.screen_name, 
              :Province => f.user.province, 
              :City => f.user.city, 
              :UserLocation => f.user.location, 
              :Profile_image_url => f.user.profile_image_url, 
              :Gender => f.user.gender , 
              :Followers_count => f.user.followers_count, 
              :Friends_count => f.user.riends_count, 
              :Statuses_coun => f.user.statuses_coun, 
              :Verified => f.user.verified,  
              :RetweetedID => f.retweeted_status ? f.retweeted_status.id : nil,
              :RuleID => rule_id, 
              :AccountID => rule_accountid, 
              :WeiboFrom => @userkey.weibo_firm,
            })
          end
        end
        
        @starttime = @endtime+1
      end
      JobArgs.update(jobargs_id,{:ArgsValue => argsvalue.to_i+86400 })
    rescue
      JobArgs.update(jobargs_id,{:ArgsValue => @starttime })
    end
  end
end