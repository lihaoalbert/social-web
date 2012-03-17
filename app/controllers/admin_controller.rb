class AdminController < ApplicationController
  def index
    @userkey = Userkey.find(:all)
    @userkey.each do |userkey|
      oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
      oauth.authorize_from_access(userkey.key1, userkey.key2)
      @userfriend = Weibo::Base.new(oauth).friend_ids({:count => 5000, :count => 0})
      #@userfriend.each do |userfriend|
      #end
    end
  end
  
  
  def data
    #rule_select_message #规则生成表
    #monitor_select_message #监控
    #sina_provinces_citis #添加地区城市
    #message_info #获取单一用户oauth-key
    #user_follower_friends #user_data_association #获取已有用户的三层数据关系
    #rule_weibo #获取规则收索微博ID
  end
  
  def job_weibo_stage
    @abc = JobArgs.count(:conditions => {:ArgsName => 2, :ArgsClass => 'LastRunTime'})
    #@ruledef = RuleDef.find(:all)
    #@ruledef.each do |ruledef|
    #  @jobargs = JobArgs.find(:first, :conditions => {:ArgsName => ruledef.id.to_s, :ArgsClass => 'LastRunTime'})
    #  if !@jobargs then
    #    JobArgs.create({
    #      :ArgsName => ruledef.id.to_s, 
    #      :ArgsClass => 'LastRunTime', 
    #      :ArgsValue => Time.mktime(2012,02,1).to_i
    #    })
    #    @jobargs = JobArgs.find(:first, :conditions => {:ArgsName => ruledef.id.to_s, :ArgsClass => 'LastRunTime'})
    #  end
    #  @userkey = Userkey.find(ruledef.AccountID) #多个用户分组，取其中一笔，多个firm，要循环（为实现）
    #  
    #  @strkeyword = ruledef.KeyWord
    #  @filter_ori = ruledef.FilterOri
    #  #@abc = @jobargs.ArgsValue
    #  @pagenum=0
    #  @total=-1
    #  
    #  #while @total == -1 or @pagenum < ((@total % 20 != 0) ? @total/20+1 : @total/20) do
    #  @starttime = @jobargs.ArgsValue.to_i
    #  begin
    #    for i in (1...1440)
    #      #@pagenum += 1
    #      #@abc = @pagenum
    #      
    #      @endtime = @jobargs.ArgsValue.to_i+60*i
    #      oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    #      oauth.authorize_from_access(@userkey.key1, @userkey.key2)
    #      @messageselect=Weibo::Base.new(oauth).status_search(@strkeyword,{:starttime => @starttime, :endtime => @endtime, :filter_ori => @filter_ori })
    #      
    #      #@total = @messageselect.total_count_maybe
    #      #if @total < 1 then
    #      #  break
    #      #end
    #      if @messageselect != "" && @messageselect != nil  then
    #        @messageselect.each do |f|
    #          WeiboStage.create({
    #            :WeiboID => f.id.to_s, 
    #            :WeiboText => f.text,
    #            :WeiboTime => f.created_at, 
    #            :WeiboSource => f.source, 
    #            :WeiboUID => f.user.id, 
    #            :ScreenName => f.user.screen_name, 
    #            :Province => f.user.province, 
    #            :City => f.user.city, 
    #            :UserLocation => f.user.location, 
    #            :Profile_image_url => f.user.profile_image_url, 
    #            :Gender => f.user.gender , 
    #            :Followers_count => f.user.followers_count, 
    #            :Friends_count => f.user.riends_count, 
    #            :Statuses_coun => f.user.statuses_coun, 
    #            :Verified => f.user.verified,  
    #            :RetweetedID => f.retweeted_status ? f.retweeted_status.id : nil,
    #            :RuleID => ruledef.id, 
    #            :AccountID => ruledef.AccountID, 
    #            :WeiboFrom => @userkey.weibo_firm,
    #          })
    #        end
    #      end
    #      
    #      @starttime = @endtime+1
    #    end
    #    @jobargs.update_attributes({:ArgsValue => @jobargs.ArgsValue.to_i+86400 })
    #  rescue
    #    @jobargs.update_attributes({:ArgsValue => @starttime })
    #  end
    #  
    #end
    ##@abc = @total
    #render :action=>"data"
    
  end
  
  def job_delete_stage
    database = YAML.load_file(File.join(Rails.root.to_s, 'config', 'database.yml'))[Rails.env || "development"]
    dbh = Mysql2::Client.new(:host => database["host"],:username => database["username"],:password => database["password"])
    dbh.query("USE `#{database['database']}`;")
    dbh.query('set names utf8;');
    sql = "insert into weibo_mains(
           `WeiboID`,`WeiboText`,`WeiboTime`,`WeiboSource`,`WeiboUID`,`ScreenName`,
           `Province`,
           `City`,`Profile_image_url`,`Gender`,
           `Followers_count`,
           `Friends_count`,
           `Statuses_coun`,
           `Verified`,
           `RetweetedID`,
           `AccountID`,
           `WeiboFrom`,`created_at`)
          select distinct `WeiboID`,
           max(`WeiboText`),
           max(`WeiboTime`),
           max(`WeiboSource`),
           max(`WeiboUID`),
           max(`ScreenName`),
           left(max(`UserLocation`), locate(' ', max(`UserLocation`))) as `Province`,
           substring(max(`UserLocation`),locate(' ', max(`UserLocation`))+1) as `City`,
           max(`Profile_image_url`),
           max(`Gender`),
           max(`Followers_count`),
           max(`Friends_count`),
           max(`Statuses_coun`),
           max(`Verified`),
           max(`RetweetedID`),
           max(`AccountID`),
           max(`WeiboFrom`), now() from weibo_stages 
           where created_at < DATE_ADD(now(),INTERVAL -600 SECOND)
              and WeiboID not in(select distinct WeiboID from weibo_mains)
            group by `WeiboID`"
    dbh.query(sql)
    sql = "insert into weibo_rules (WeiboID, RuleID, WeiboTime, WeiboFrom, created_at)
           select distinct WeiboID, RuleID, WeiboTime, 
             case when WeiboFrom='sinaweibo' then 1 else 0 end as WeiboFrom , 
             DATE_ADD(now(),INTERVAL -600 SECOND) as created_at
            from weibo_stages 
             where created_at < DATE_ADD(now(),INTERVAL -600 SECOND)
             and weiboID + '-' + RuleID not in(select distinct weiboID + '-' + RuleID from weibo_rules)"
    dbh.query(sql)
    sql = "delete from weibo_stages 
           where WeiboID in (select WeiboID from weibo_rules)
           and created_at < (select max(created_at)  from weibo_rules)"
    dbh.query(sql)
    dbh.close
    render :action=>"data"
  end
  
  #获取规则收索微博ID
  def rule_weibo
    @rulemessage = RuleMessage.find(:all)
    @rulemessage.each do |rulemessage|
      @userkey = Userkey.find(rulemessage.id)
      oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
      oauth.authorize_from_access(@userkey.key1, @userkey.key2)
      @strkeyword = rulemessage.keyword
      @filter_ori = rulemessage.filterori
      @messageselect=Weibo::Base.new(oauth).status_search(strkeyword,{:filter_ori => @filter_ori })
      @messageselect.each do |messageselect|
        
      end
    end
  end
  
  #根据规则获取数据
  def rule_select_message
    @testmessage = RuleMessage.find(:all)
    @txtint = 0
    @testmessage.each do |strmessage|
      rule_id = strmessage.id
      @userkey = Userkey.find(strmessage.user_id)
      oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
      oauth.authorize_from_access(@userkey.key1, @userkey.key2)
      @strrulename = strmessage.rulename
      if !(@strrulename == "") then
        straname = @strrulename.split(",")
        straname.each do |rulename|
          @userselect=Weibo::Base.new(oauth).user_search(rulename)
           @userselect.each do |struser|
             user_id = strmessage.user_id
             uid = struser.id
             screen_name = struser.screen_name
             name = struser.name
             province = struser.province
             city = struser.city
             location = struser.location
             url = struser.url
             profile_image_url = struser.profile_image_url
             domain = struser.domain
             gender = struser.gender
             created_user = struser.created_at
             geo_enabled = struser.geo_enabled
             followers_count = struser.followers_count
             friends_count = struser.friends_count
             statuses_count = struser.statuses_count
             favourites_count = struser.favourites_count
             @number = UsernameSelect.count(:conditions =>  "UID='#{uid}'")
             if @number == 0 then 
               UsernameSelect.create({
                 :user_id => user_id, 
                 :UID => uid, 
                 :screen_name => screen_name, 
                 :name => name, 
                 :province => province, 
                 :city => city, 
                 :location => location, 
                 :url => url, 
                 :profile_image_url => profile_image_url, 
                 :domain => domain, 
                 :gender => gender, 
                 :created_user => created_user, 
                 :followers_count => followers_count, 
                 :friends_count => friends_count, 
                 :statuses_count => statuses_count, 
                 :favourites_count => favourites_count, 
                 :rule_id => rule_id, 
                 :rulename => rulename 
               })
             else
               usernameselect = UsernameSelect.find_by_UID(uid)
               usernameselect.update_attributes({:rulename => "'#{usernameselect.rulename}','#{rulename}'"})
             end
           end
        end
      end
      
      @strkeyword = strmessage.keyword
      @filter_ori = strmessage.filterori
      if !(@strkeyword == "") then
        stra = @strkeyword.split(",")
        stra.each do |strkeyword|
          @messageselect=Weibo::Base.new(oauth).status_search(strkeyword,{:filter_ori => @filter_ori })
          @messageselect.each do |messageselect|
            user_id = strmessage.user_id
            created_w = messageselect.created_at
            wid = messageselect.id
            wtext = messageselect.text
            if messageselect.source == nil || messageselect.source == ""
              source = " "
            else
              source = messageselect.source
            end
            wuser_id = messageselect.user.id
            screen_name = messageselect.user.screen_name
            user_name = messageselect.user.name
            user_location = messageselect.user.location
            profile_image_url = messageselect.user.profile_image_url
            @number = DisplayMessage.count(:conditions => "WID='#{wid}'")
            if @number == 0 then 
              DisplayMessage.create({
                :user_id => user_id,
                :created_w => created_w,
                :WID => wid,
                :wtext => wtext,
                :source => source,
                :wuser_id => wuser_id,
                :screen_name => screen_name,
                :user_name => user_name,
                :user_location => user_location,
                :profile_image_url => profile_image_url,
                :monitor => 0, 
                :rule_id => rule_id, 
                :rulekeyword => strkeyword
              })
            else
              displaymessage = DisplayMessage.find_by_WID(wid)
              displaymessage.update_attributes(:rulekeyword => "'#{displaymessage.rulekeyword}','#{strkeyword}'")
            end
          end
        end
      end
    end
    render :action=>"data"
  end
  
  def monitor_select_message
    @monitormesaage = UploadMessage.find(:all, :conditions => "monitor = 1 and Wbid is not null")
    if @monitormesaage != [] then
      @monitormesaage.each do |monitormesaage|
        @userkey = Userkey.find(monitormesaage.user_id)
        oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
        oauth.authorize_from_access(@userkey.key1, @userkey.key2)
        @messageoneselect = Weibo::Base.new(oauth).status(monitormesaage.Wbid)
        numcomments = @messageoneselect.comments_count
        numreposts = @messageoneselect.reposts_count
        if numcomments == nil then
          numcomments = 0
        end
        if numreposts == nil then
          numreposts = 0
        end
        MonitorMessage.create({:WID => @messageoneselect.id, :reposts_count => numreposts, :comments_count => numcomments })
      end
    end
    render :action=>"data"
  end
  
  def sina_provinces_citis
    message_info
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_access($txtkey1, $txtkey1)
    provinces_city=Weibo::Base.new(oauth).provinces()
    provinces_city.provinces.each do |provincescity|
      provincesid = provincescity.id
      provincesname = provincescity.name
      if provincesid == 100 || provincesid == 400 then
        ProvinceCity.create({
          :NodeClass => "REST", 
          :Code => provincesid, 
          :ParentCode => "REST", 
          :Name => provincesname 
        });
        provincescity.citys.each do |citys|
          citystr = citys.to_s.split(" ")[1]
          citystr = citystr[0,citystr.length-1].to_s.split("=")
          citysid = citystr[0]
          citysname = citystr[1].strip
          citysname = citysname[1,citysname.length-2].to_s
          ProvinceCity.create({
          :NodeClass => provincesid, 
          :Code => citysid, 
          :ParentCode => provincesid, 
          :Name => citysname 
        });
        end
        else
        ProvinceCity.create({
          :NodeClass => "AREA", 
          :Code => provincesid, 
          :ParentCode => "CN", 
          :Name => provincesname 
        });
        provincescity.citys.each do |citys|
          citystr = citys.to_s.split(" ")[1]
          citystr = citystr[0,citystr.length-1].to_s.split("=")
          citysid = citystr[0]
          citysname = citystr[1].strip
          citysname = citysname[1,citysname.length-2].to_s
          ProvinceCity.create({
          :NodeClass => provincesid, 
          :Code => citysid, 
          :ParentCode => provincesid, 
          :Name => citysname 
        });
        end
      
      end
    end
    render :action=>"data"
  end
  
  def user_message
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
    render :action=>"data"
  end
  
  def user_follower_friends
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
    render :action=>"data"
  end
  
  def message_info
    if user_signed_in?
      @userkey = Userkey.find(current_user.id)
      $txtkey1 = @userkey.key1
      $txtkey2 = @userkey.key2
      $weibofirm = @userkey.weibo_firm
    else
      @userkey = Userkey.find(1)
      $txtkey1 = @userkey.key1
      $txtkey2 = @userkey.key2
      $weibofirm = @userkey.weibo_firm
      #$txtkey1 = "11d3f4ba88c23cb0ff2e15dd0ab1d1fc"
      #$txtkey2 = "763739c2df44939b7caa41f0b9a00506"
    end
  end
  
  def message_infos
    
  end
  
  def countadd
    abc = Rulenumber1.new
    abc.txttree
  end

end

class Rulenumber1
  def txttree
    database = YAML.load_file(File.join(Rails.root.to_s, 'config', 'database.yml'))[Rails.env || "development"]
    dbh = Mysql2::Client.new(:host => database["host"],:username => database["username"],:password => database["password"])
    dbh.query("USE `#{database['database']}`;")
    dbh.query('set names utf8;');
    sql = "delete from rulenumbers where created_at >= " + Time.new.strftime("%Y-%m-%d")
    dbh.query(sql)
    sql = "insert into rulenumbers(RuleID, RuleNum, created_at) 
    select RuleID,count(*), now() from weibo_rules group by RuleID"
    dbh.query(sql)
    dbh.close
    
    treeall = RuleDef.find(:all, :conditions => ["RuleType = 1"])
    treeall.each do |t|
      if RuleDef.count(:conditions => ["ParentID = ?", t.id]) == 0 then
        addparent(t.id)
      end
    end
    rnall = Rulenumber.find(:all, :conditions => ["created_at >= ?", Time.new.strftime("%Y-%m-%d")])
    rnall.each do |r|
      if RuleDef.count(:conditions => ["id = ?", r.RuleID]) > 0  then
        RuleDef.update(r.RuleID,{:MonitCnt => r.RuleNum})
      end
    end
  end
  
  def addparent(ruleid)
    @parentid = RuleDef.find(ruleid).ParentID ? RuleDef.find(ruleid).ParentID : -1
    if @parentid != -1 then
      @parent = Rulenumber.find(:all,:conditions => ["RuleID = ?",@parentid])
      @sun = Rulenumber.find(:all,:conditions => ["RuleID = ?",ruleid])
      @count = @sun[0].RuleNum.to_i + @parent[0].RuleNum.to_i
      Rulenumber.update(@parent[0].id,{:RuleNum => @count})
      addparent(@parentid)
    end
  end
end
