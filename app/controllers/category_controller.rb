#encoding: utf-8
require 'csv'
class CategoryController < ApplicationController
  def index
    @strsql = ""
    @txtkeyword = params[:txtkeyword]
    #cookies[:txtkeyword] = @txtkeyword
    cookies[:datecustom] = params[:datecustom]
    
    if params[:page].to_i >= 1 then 
      @pageid = (params[:page].to_i-1) * 50 + 1
    else
      @pageid = 1
      cookies[:txtkeyword] = nil
      cookies[:strsql] = nil
    end
    
    if user_signed_in?
      @userid = current_user.id
    else
      #@userid = 1
      redirect_to :controller => 'home'
    end
    @id = params[:id]
    
    case cookies[:datecustom].to_s
    when 'all'
      if params[:rulechecked] == nil
        cookies[:rulechecked] = nil
         @strsql = nil
      end
      cookies[:enddate] = nil
      cookies[:startdate] = nil
    when 'week'
      if params[:rulechecked] == nil
        cookies[:rulechecked] = nil
      end
      enddate = Time.new.strftime("%Y-%m-%d")
      startdate = (Time.new-7*24*60*60).strftime("%Y-%m-%d")
      @strsql += " and weibo_mains.WeiboTime <= '#{enddate}' and weibo_mains.WeiboTime >= '#{startdate}'"
      cookies[:enddate] = enddate     
      cookies[:startdate] = startdate 
      cookies[:strsql] = @strsql
    when 'month'
      if params[:rulechecked] == nil
        cookies[:rulechecked] = nil
      end
      enddate = Time.new.strftime("%Y-%m-%d")
      startdate = (Time.new-30*24*60*60).strftime("%Y-%m-%d")
      @strsql += " and weibo_mains.WeiboTime <= '#{enddate}' and weibo_mains.WeiboTime >= '#{startdate}'"
      cookies[:enddate] = enddate     
      cookies[:startdate] = startdate 
      cookies[:strsql] = @strsql
    end
    
    if params[:txtkeyword] != nil && params[:txtkeyword] != "" then
      @txtkeyword = params[:txtkeyword]
      cookies[:txtkeyword] = @txtkeyword
      if @strsql == nil then
        @strsql = " and weibo_mains.WeiboText LIKE '%#{@txtkeyword}%'"
      else
        @strsql += " and weibo_mains.WeiboText LIKE '%#{@txtkeyword}%'"
      end
      cookies[:strsql] = @strsql
      @txtkeyword = cookies[:txtkeyword]
      @abc = @txtkeyword
    else
      @txtkeyword = cookies[:txtkeyword]
      @strsql = cookies[:strsql]
    end
    
    if @id != nil then
      @strid = @id + "," + addrulid(@id,"")
      @strid = @strid[-1] == "," ? @strid.chop : @strid      
      #@categoryone = RuleDef.find(@id)
      @category = RuleDef.find(:all,:conditions=>[" ParentID is null and AccountID = ? and RuleType = 1", @userid])
      @products = WeiboRule.paginate(:page => params[:page], :per_page => 50, :joins => "LEFT JOIN `weibo_mains` ON weibo_mains.WeiboID = weibo_rules.WeiboID", :select => "weibo_mains.WeiboText,weibo_mains.WeiboTime,weibo_mains.RetweetedID", :conditions => ["weibo_rules.WeiboID in (select WeiboID from weibo_mains where AccountID = ? ) and weibo_rules.RuleID in (#{@strid.to_s}) #{@strsql}",@userid] )
    else
      @category = RuleDef.find(:all,:conditions=>[" ParentID is null and AccountID = ? and RuleType = 1", @userid])
      @products = WeiboRule.paginate(:page => params[:page], :per_page => 50, :joins => "LEFT JOIN `weibo_mains` ON weibo_mains.WeiboID = weibo_rules.WeiboID", :select => "weibo_rules.id,weibo_mains.WeiboText,weibo_mains.WeiboTime,weibo_mains.RetweetedID", :conditions => ["weibo_rules.WeiboID in (select WeiboID from weibo_mains where AccountID = ?) #{@strsql} ",@userid] )
    end
    @weibomains = @products
  end
  
  def addrulid(ruleid,str)
    strid = RuleDef.find(:all, :conditions => ["ParentID=?",ruleid])
    strid.each do |s|
      str = s.id.to_s + "," + addrulid(s.id,str).chop
    end
    return str
  end
  
  def edit
    if user_signed_in?
      @userid = current_user.id
    else
      #@userid = 1
      redirect_to :controller => 'home'
    end
    @category = RuleDef.find(:all,:conditions=>[" ParentID is null and AccountID = ? and RuleType = 1", @userid])
    @id = params[:id]
    @categoryone = RuleDef.find(@id)
  end
  
  def new
    if user_signed_in?
      @userid = current_user.id
    else
      #@userid = 1
      redirect_to :controller => 'home'
    end
    @id = params[:parentid]
    @category = RuleDef.find(:all,:conditions=>[" ParentID is null and AccountID = ? and RuleType = 1", @userid])
    @categoryone = RuleDef.new
    @categoryone.ParentID = @id
  end
  
  def save_category
    id = params[:id]
    name = params[:rulename]
    keyword = params[:keyword]
    parentid = params[:parentid]
    filterori = params[:filterori]
    if id == "" || id == nil then
      RuleDef.create({
        :AccountID => current_user.id,
        :RuleName => name, 
        :KeyWord => keyword,
        :ParentID => parentid,
        :FilterOri => filterori,
        :RuleType => 1
      })
      id = parentid
    else
      RuleDef.update(id,{
        :RuleName => name, 
        :KeyWord => keyword,
        :ParentID => parentid,
        :FilterOri => filterori
      })
    end
    redirect_to :action => 'index', :id => id
  end
  
  def csv_export
    if user_signed_in?
      @userid = current_user.id
    else
      #@userid = 1
      redirect_to :controller => 'home'
    end
    @id = params[:id]
    @txtkeyword = params[:txtkeyword]
    if @id != nil then
      @strid = @id + "," + addrulid(@id,"")
      @strid = @strid[-1] == "," ? @strid.chop : @strid
      @products = WeiboRule.find(
        :all, 
        :joins => "LEFT JOIN `weibo_mains` ON weibo_mains.WeiboID = weibo_rules.WeiboID", 
        :select => "weibo_mains.WeiboText,weibo_mains.WeiboTime,weibo_mains.RetweetedID,weibo_mains.ScreenName,weibo_mains.Province,weibo_mains.City,weibo_mains.Gender,weibo_mains.Followers_count,weibo_mains.Friends_count,weibo_mains.WeiboFrom as Form", 
        :conditions => ["weibo_rules.WeiboID in (select WeiboID from weibo_mains where AccountID = ? ) and weibo_rules.RuleID in (#{@strid.to_s}) and weibo_mains.WeiboText LIKE '%#{@txtkeyword}%'",@userid] 
      )
    else
      @products = WeiboRule.find(
        :all, 
        :joins => "LEFT JOIN `weibo_mains` ON weibo_mains.WeiboID = weibo_rules.WeiboID", 
        :select => "weibo_mains.WeiboText,weibo_mains.WeiboTime,weibo_mains.RetweetedID,weibo_mains.ScreenName,weibo_mains.Province,weibo_mains.City,weibo_mains.Gender,weibo_mains.Followers_count,weibo_mains.Friends_count,weibo_mains.WeiboFrom as Form", 
        :conditions => ["weibo_rules.WeiboID in (select WeiboID from weibo_mains where AccountID = ?) and weibo_mains.WeiboText LIKE '%#{@txtkeyword}%'",@userid] 
      )
    end

    csv_data = CSV.generate do |csv|
      csv << ["时间", "原创/转发", "用户", "省", "市", "性别", "粉丝数", "关注数", "来源", "内容"]
      @products.each do |t|
        csv << [
          t.WeiboTime.strftime("%Y-%m-%d"),
          t.RetweetedID == nil ? "原创" : "转发",
          t.ScreenName,
          t.Province,
          t.City,
          case t.Gender 
          when "m" then
            "男"
          when "f" then
              "女"
          else return ""
          end,
          t.Followers_count,
          t.Friends_count,
          case t.Form.strip
          when "sinaweibo" then
            "新浪微博"
          end,
          t.WeiboText
        ]
      end
    end
    #file = File.new('coupons.csv')
    @filename = "export_#{Time.new.strftime("%Y_%m_%d")}.csv"
    File.open("public/download/#{@filename}", 'w') {|f| f.write(csv_data) }
    io=File.open("#{Rails.root}/public/download/#{@filename}")
    io.binmode
    send_data(io.read,
     :filename=> @filename,
     :type => "text/csv;charset=utf-8; header=present"
    )
    io.close                                                  
  end

end