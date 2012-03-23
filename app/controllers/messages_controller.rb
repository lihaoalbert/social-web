#encoding : utf-8
class MessagesController < ApplicationController
  before_filter :account_info
  
  #微博首页
  def timeline
    if account_info then
      @key1 = account_info[0]
      @key2 = account_info[1]
      oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
      oauth.authorize_from_access(@key1,@key2)
      @mlist = Weibo::Base.new(oauth).friends_timeline
    end
  end
  
  #@我的微博
  def mentions
    if account_info then
      @key1 = account_info[0]
      @key2 = account_info[1]
      oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
      oauth.authorize_from_access(@key1,@key2)
      @mlist = Weibo::Base.new(oauth).replies
    end
  end
  
  #我的微博
  def user_timeline
    if account_info then
      @key1 = account_info[0]
      @key2 = account_info[1]
      oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
      oauth.authorize_from_access(@key1,@key2)
      @mlist = Weibo::Base.new(oauth).user_timeline
    end
  end
  
  #我发出的评论
  def comments_by_me
    if account_info then
      @key1 = account_info[0]
      @key2 = account_info[1]
      oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
      oauth.authorize_from_access(@key1,@key2)
      @mlist = Weibo::Base.new(oauth).comments_by_me
    end
  end
  
  #我收到的评论
  def comments_to_me
    if account_info then
      @key1 = account_info[0]
      @key2 = account_info[1]
      oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
      oauth.authorize_from_access(@key1,@key2)
      @mlist = Weibo::Base.new(oauth).comments_to_me
    end
  end
  
  #回复评论
  def answer
    if user_signed_in?
      @userid = current_user.id
    else
      #@userid = 1
      redirect_to :controller => 'home'
    end
  end
  
  #数据导出
  def output
    if user_signed_in?
      @userid = current_user.id
    else
      #@userid = 1
      redirect_to :controller => 'home'
    end
  end
  
  def upload_message
    if user_signed_in?
      @userid = current_user.id
    else
      #@userid = 1
      redirect_to :controller => 'home'
    end
    
    if (session["imagefile"] != nil) then
      @imgf = session["imagefile"]
    else
      @imgf = ""
    end
    
    @strmessage = UploadMessage.find(:all, :conditions => "isselected!=0", :order => "id desc")
  end
  
  def upload_edit
    stronemessage = UploadMessage.find_by_id(params[:id])
    @txtid= stronemessage.id
    @txtmessage = stronemessage.message.strip
    @imgf = stronemessage.image
    @txtisselected = stronemessage.isselected
    @txtmonitor = stronemessage.monitor
    
    if (session["imagefile"] != nil) then
      @imgf = session["imagefile"]
    else
      @imgf = ""
    end
    
    respond_to do |format|
      format.html { render :layout => false } #:layout => false 设置不使用页面框架
      format.json  { render :json => @strselectmessage }
    end
  end
  
  def upload
    image=params[:img]
    strtxt = params[:strtxt]
    content_size=image.size
    file_data=image.read
    filetype=image.content_type
    @filename=image.original_filename
    fileext=File.basename(@filename).split(".")[1]
    @time=Time.now.strftime("%Y-%m-%d-%H-%M-%S")
    timeext=File.basename(@time)
    newfilename=timeext+"."+fileext
    File.open("#{Rails.root}/public/"+ newfilename,"wb"){
      |f| f.write(file_data)
    }
    session["imagefile"] = newfilename
    redirect_to strtxt
    #render :action=>"upload_message"
  end
  
  def img_message
    respond_to do |format|
      format.html { render :layout => false } #:layout => false 设置不使用页面框架
      #format.json  { render :json => @home }
    end
  end
    
  def save_update
    @strtype = params[:strtype]
    if @strtype == "userrule" then
      if user_signed_in?
        @userid = current_user.id
      else
        @userid = 1
      end
      @strrulename = params[:strrulename]
      @strkeyword = params[:strkeyword]
      @strusername = params[:strusername]
      @filterori = params[:filterori]
      @strruleid = params[:strruleid]
      if @strruleid == nil || @strruleid == "" then
        RuleMessage.create({:user_id => @userid, :rulename => @strrulename})
        @datamessage = RuleMessage.find(:last,:conditions => "user_id = " + @userid.to_s).to_json
      else
        rulemessage = RuleMessage.find(@strruleid)
        ifSucuss=rulemessage.update_attributes({:rulename => @strrulename, :keyword => @strkeyword, :username => @strusername, :filterori => @filterori});
        if ifSucuss then
         #flash[:notice] = "保存成功" #notice 存放提示信息  
         @test = "更改已保存成功" #notice 存放提示信息  
        else
           @test = "保存出错" #notice 存放提示信息 
      end
        @datamessage = @test
      end
    end
    
    #创建一篇微博
    if @strtype == "savemessage" then
      @strmessage = params[:strmes]
      @strimage = params[:strimg]
      @sendstate = params[:send_state]
      @struploadtime = Time.now+params[:clock].to_i*60
      @strmonitor = params[:strmonitor]
      @strweibofirm = "sinaweibo"
      if user_signed_in?
        @strusername = current_user.email
        @struserid = current_user.id
      else
        @strusername = "eric_yue"
        @struserid = 1
      end
      @strid = params[:strid]
      if !@strmessage.blank? && !@strimage.blank? then
        UploadMessage.create({
          :message => @strmessage, 
          :image => @strimage, 
          :isselected => @sendstate, 
          :uploadtime => @struploadtime, 
          :username => @strusername, 
          :user_id => @struserid, 
          :monitor => @strmonitor, 
          :weibo_firm => @strweibofirm 
        })
        struser = UploadMessage.find(:last, :conditions => "username = '" + @strusername.to_s + "'")
        #struser = UploadMessage.find(:last, :conditions => "username = '" + @strusername.to_s + "'")
        #redirect_to "/messages/test_message"
        #Delayed::Job.enqueue(Jobsmessage.new(@strmessage,@strimage),3, 1.minute.from_now)
        if @strmonitor == 1 then
          
        end
        if @sendstate == 1 then
          Jobsmessage.new(@strmessage,@strimage,struser.id,@struserid)
        end
      else 
        if !@strmessage.blank?
          UploadMessage.create({
            :message => @strmessage, 
            :isselected => @sendstate, 
            :uploadtime => @struploadtime, 
            :username => @strusername, 
            :user_id => @struserid, 
            :monitor => @strmonitor, 
            :weibo_firm => @strweibofirm 
          })
          struser = UploadMessage.find(:last, :conditions => "username = '" + @strusername.to_s + "'")
          
          #判断是否监控，监控向监控表中插入一笔数据
          if @strmonitor == 1 then
            
          end
          
          #判断是否即时发送
          if @sendstate == 1 then
            Jobsmessage.new(@strmessage,@strimage,struser.id)
          end
        end
      end
      
      #对列表中已有的数据作批次删除（做标志位为：0）
      if !@strid.blank? then
        str = @strid.split(",")
        str.each do |strid|
          messupdate = UploadMessage.find(strid)
          messupdate.update_attributes({:isselected => 0})
        end
      end
    end
    
    if @strtype == "monitor" then
      datamonitor = DisplayMessage.find_by_WID(params[:wbid])
      datamonitor.update_attributes({:monitor => params[:strnum]});
    end
    
    if @strtype == "deletemessage" then
      @strid = params[:strid]
      if !@strid.blank? then
        str = @strid.split(",")
        str.each do |strid|
          messupdate = UploadMessage.find(strid)
          messupdate.update_attributes({:isselected => 0})
        end
      end
    end
    
    if @strtype == "deletemessage" then
      @strid = params[:strid]
      if !@strid.blank? then
        messupdate = UploadMessage.find(strid)
        messupdate.update_attributes({:isselected => 0})
      end
    end
    
    if @strtype == "updatemessage" then
      @strid = params[:strid]
      if !@strid.blank? then
        @strmessage = params[:strmessage]
        @strimage = params[:strimg]
        if @strimage == "" then
          @strimage = nil
        end
        @strmonitor = params[:strmonitor]
        @sendstate = params[:send_state]
        @struploadtime = Time.now+params[:clock].to_i*60
        @strmonitor = params[:strmonitor]
        messupdate = UploadMessage.find(@strid)
        messupdate.update_attributes({
          :message => @strmessage, 
          :image => @strimage, 
          :uploadtime => @struploadtime, 
          :isselected => @sendstate, 
          :weibo_firm => @strweibofirm, 
          :monitor => @strmonitor 
        })
      end
    end
    
    if @strtype == "addfollow" then
       userid = params[:userid]
       oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
      oauth.authorize_from_access(@txtkey1,@txtkey2)
      Weibo::Base.new(oauth).friendship_create(userid)
    end
    
    respond_to do |format|
      format.html { render :layout => false } #:layout => false 设置不使用页面框架
      #format.json  { render :json => @home }
    end
  end
 
  def jobs_message
    
  end

  def select_message
    if user_signed_in?
      @userid = current_user.id
    else
      redirect_to :controller => 'home'
    end
  end

  #定义关键词规则页面
  def userrule_message
    @rulenum = 0
    if user_signed_in?
      @rulemessage = RuleMessage.find(:all, :conditions => "user_id = " + current_user.id.to_s, :order => "id DESC")
    else
      @rulemessage = RuleMessage.find(:all, :conditions => "user_id = 1", :order => "id DESC")
    end
    strid = params[:id]
    if (strid != nil && strid != "")
      @strid = strid
      @rulenum = RuleMessage.count_by_sql("select count(*) from rule_messages where id=#{strid} ")
      @ruleonemessage = RuleMessage.find_by_id(strid)
    end
        
    respond_to do |format|
      format.html { render :layout => true } #:layout => false 设置不使用页面框架
      format.json  { render :json => @rulemessage }
    end
  end
  
  #微博查询结果显示
  def display_message
    strq = params[:strq]
    strfilterori = params[:strfilterori].to_i    
    strfilterpic = params[:strfilterpic].to_i
    strfiltertime = params[:strfiltertime].to_i
    @strfiltertime= params[:strfiltertime]
    @intstart=case 
    		when strfiltertime==0
    					""#Time.mktime(Time.now.year.to_i,Time.now.month.to_i,Time.now.day.to_i).to_i
    		when strfiltertime==1
    					Time.mktime(Time.now.year.to_i,Time.now.month.to_i,Time.now.day.to_i).to_i
    		when strfiltertime==2
    					Time.mktime(Time.now.year.to_i,Time.now.month.to_i,Time.now.day.to_i).to_i - 86400
    		when strfiltertime==3
    					Time.mktime(Time.now.year.to_i,Time.now.month.to_i,Time.now.day.to_i).to_i - 86400*20
    		end
    @intend=case 
    		when strfiltertime==0
    					""#Time.mktime(Time.now.year.to_i,Time.now.month.to_i,Time.now.day.to_i).to_i + 
    		when strfiltertime==1
    					Time.mktime(Time.now.year.to_i,Time.now.month.to_i,Time.now.day.to_i).to_i + 86400
    		when strfiltertime==2
    					Time.mktime(Time.now.year.to_i,Time.now.month.to_i,Time.now.day.to_i).to_i 
    		when strfiltertime==3
    					Time.mktime(Time.now.year.to_i,Time.now.month.to_i,Time.now.day.to_i).to_i - 86400
    		end
    if(strq == nil || strq == "") then
      @strmessage=""
      if user_signed_in?
        #@strselectmessage = DisplayMessage.find_all_by_user_id(current_user.id)
        @strselectmessage = DisplayMessage.find(:all, :conditions => "user_id=" + current_user.id.to_s, :order => "id desc")
      else
        #@strselectmessage = DisplayMessage.find_all_by_user_id(1)
        @strselectmessage = DisplayMessage.find(:all, :conditions => "user_id=1", :order => "id desc")
      end
    else
      oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
      #oauth.authorize_from_access("11d3f4ba88c23cb0ff2e15dd0ab1d1fc","763739c2df44939b7caa41f0b9a00506")
      oauth.authorize_from_access(@txtkey1,@txtkey2)
      @strmessage=Weibo::Base.new(oauth).status_search(strq,{:filter_pic => strfilterpic, :filter_ori => strfilterori,:starttime => @intstart, :endtime => @intend })
    end
    respond_to do |format|
      format.html { render :layout => false } #:layout => false 设置不使用页面框架
      #format.json  { render :json => @home }
    end
  end
  
  def edit_message
    @typetxt = params[:type]
    if (@typetxt == "repost") then
      @txttype = "转发"
      @txtmessage = "添加的转发文本"
    else
      @txttype = "评论"
      @txtmessage = "添加的评论文本"
    end
    @txtwbid = params[:wbid]
    @strmessage=""
      oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
      #oauth.authorize_from_access("11d3f4ba88c23cb0ff2e15dd0ab1d1fc","763739c2df44939b7caa41f0b9a00506")
      oauth.authorize_from_access(@txtkey1,@txtkey2)
      @strmessage=Weibo::Base.new(oauth).comments({:id => @txtwbid, :count => 10 })
    
    
    respond_to do |format|
      format.html { render :layout => false } #:layout => false 设置不使用页面框架
      #format.json  { render :json => @home }
    end
  end
  
  def repost_message
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_access(@txtkey1,@txtkey2)
    #@abc = Weibo::Base.new(oauth).friends_timeline.to_json
    if (params[:type] == "repost") then
      @abc = Weibo::Base.new(oauth).repost(params[:wbid],{:status  => params[:repost]})
    elsif (params[:type] == "comment") then
      @abc = Weibo::Base.new(oauth).comment(params[:wbid],params[:repost])
    end
  end
  
  #手动执行关键词规则搜索任务
  def monitor_select_message
    @monitormesaage = UploadMessage.find(:all, :conditions => "monitor = 1 and Wbid is not null") #monitor=1 标志监控
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
  end

# 规则生成表
  def rule_select_message
    @testmessage = RuleMessage.find(:all)
    @txtint = 0
    @testmessage.each do |strmessage|
      rule_id = strmessage.id
      @userkey = Userkey.find(strmessage.user_id)
      oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
      oauth.authorize_from_access(@userkey.key1, @userkey.key2)
      @userselect=Weibo::Base.new(oauth).user_search(strmessage.rulename)
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
        @number = Userkey.count_by_sql("select count(*) from username_selects where uid='#{uid}'")
        if @number == 0
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
            :rule_id => rule_id 
          });
        end
      end
      @strkeyword = strmessage.keyword
      @filter_ori = strmessage.filterori
      if !(@strkeyword == "") then
        stra = @strkeyword.split(",")
        stra.each do |strkeyword|
          @messageselect=Weibo::Base.new(oauth).status_search(strkeyword,{:filter_ori => @filter_ori, :filter_ori => @filter_ori })
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
            @number = DisplayMessage.count_by_sql("select count(*) from display_messages where wid='#{wid}'")
            if @number == 0
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
                :rule_id => rule_id 
              });
            end
          end
        end
      end
    end
  end

  
  def user_display_message
    if user_signed_in?
      @user_select_message = UsernameSelect.find_all_by_user_id(current_user.id)
    else
      @user_select_message = UsernameSelect.find_all_by_user_id(1)
    end
    
    respond_to do |format|
      format.html { render :layout => false } #:layout => false 设置不使用页面框架
      #format.json  { render :json => @home }
    end
  end

  def sina_provinces_citis
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_access(@txtkey1, @txtkey1)
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
  end
  
  private
  #获取当前登录帐号的 微博user 信息
  def account_info
    if user_signed_in?
      @userkey = Userkey.find(current_user.id)
      @txtkey1 = @userkey.key1
      @txtkey2 = @userkey.key2
      oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
      oauth.authorize_from_access(@txtkey1,@txtkey2)
      #获取当前登录帐号的 微博user 信息
      @account=Weibo::Base.new(oauth).verify_credentials()
      return [@txtkey1,@txtkey2]
    else
      redirect_to :controller => 'home'
      return false
    end
  end
  
  #获取列表中用户与当前帐号的关注关系
  def selfriendship(txtuserselect)
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_access(@txtkey1, @txtkey2)
    friendship = Array.new
    txtuserselect.each do |userselect|
      usergz = Weibo::Base.new(oauth).friendship_show({:source_id  => @account.id, :target_id => userselect.id })
      friendship.push(usergz.source.following)
    end
    return friendship
  end    

end

#任务测试
class Jobsmessage
  
  def initialize(strm,strimage)
    @@mstr = strm
    @@imagestr = strimage
    message_info
    if (strimage == nil && strimage == "") then
      updatemessage.deliver
    else
      uploadmessage.deliver
    end
    
  end
  def uploadmessage
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_access(@txtkey1,@txtkey2)
    #Weibo::Base.new(oauth).upload(CGI::escape(@@mstr),File.new("D:\\test\\social-web\\public\\" + @@imagestr ,"rb"))
    Weibo::Base.new(oauth).upload(CGI::escape(@@mstr),File.new(File.join(Rails.root.to_s, 'public', @@imagestr) ,"rb"))
  end
  
  def updatemessage
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_access(@txtkey1,@txtkey2)
    Weibo::Base.new(oauth).update(@@mstr)
  end
  
  def perform
    webc.deliver
  end
  
  def message_info
    if user_signed_in?
      @userkey = Userkey.find(current_user.id)
      #$txtkey1 = "11d3f4ba88c23cb0ff2e15dd0ab1d1fc"
      #$txtkey2 = "763739c2df44939b7caa41f0b9a00506"
      $txtkey1 = @userkey.key1
      $txtkey2 = @userkey.key2
    end
  end
  
  def send_monitor
    
  end
end