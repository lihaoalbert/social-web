class RuleSelectMessage
  @queue = :webo_jobs
  def self.perform
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
  end
end