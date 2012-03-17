#encoding:utf-8
class SearchingController < ApplicationController
  def rule_list
    @strsql = ""
    @strrul = ""
    cookies[:datecustom] = params[:datecustom]
    rulechecked = Array.new
    rulechecked = params[:rulechecked]
    if rulechecked != nil then 
      rulechecked.each do |strrule|
        @strsql += "and WeiboText LIKE '%#{strrule}%'"
        @strrul += strrule
      end
      cookies[:rulechecked] = @strrul
      cookies[:strsql] = @strsql
      @rulechecked = cookies[:rulechecked]
    end    
    
    if params[:page].to_i >= 1 then 
      @id = (params[:page].to_i-1) * 50 + 1
      @rulechecked = cookies[:rulechecked]
    else
      @id = 1
      cookies[:wbtxt] = nil
      if params[:rulechecked] == nil || params[:rulechecked] == "" then
        cookies[:strsql] = nil
      end
    end
    
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
      @strsql += " and WeiboTime <= '#{enddate}' and WeiboTime >= '#{startdate}'"
      cookies[:enddate] = enddate     
      cookies[:startdate] = startdate 
      cookies[:strsql] = @strsql
    when 'month'
      if params[:rulechecked] == nil
        cookies[:rulechecked] = nil
      end
      enddate = Time.new.strftime("%Y-%m-%d")
      startdate = (Time.new-30*24*60*60).strftime("%Y-%m-%d")
      @strsql += " and WeiboTime <= '#{enddate}' and WeiboTime >= '#{startdate}'"
      cookies[:enddate] = enddate     
      cookies[:startdate] = startdate 
      cookies[:strsql] = @strsql
    when 'user'
      if params[:rulechecked] == nil
        cookies[:rulechecked] = nil
      end
      enddate = params[:enddate]
      startdate = params[:startdate]
      @strsql += "and WeiboTime <= '#{enddate}' and WeiboTime >= '#{startdate}'"
      cookies[:enddate] = enddate     
      cookies[:startdate] = startdate 
      cookies[:strsql] = @strsql      
    end
    
    #if enddate != nil && startdate != nil then
    #  cookies[:enddate] = enddate
    #  cookies[:startdate] = startdate
    #  cookies[:strsql] = @strsql
    #end
    
    if params[:wbtxt] != nil && params[:wbtxt] != "" then
      @wbtxt = params[:wbtxt]
      cookies[:wbtxt] = @wbtxt
    else
      @wbtxt = cookies[:wbtxt]
      @strsql = cookies[:strsql]
    end
    
    
    
    if user_signed_in?
      @userid = current_user.id
    else
      #@userid = 1
      redirect_to :controller => 'home'
    end
    @ruledef = RuleDef.find(:all, :conditions => ["AccountID = '?' and RuleType <> ? ",@userid,0 ] )
    if @wbtxt != nil && @wbtxt != "" then
      #@weibomains = WeiboMain.find(:all, :conditions => ["AccountID = '?' and WeiboText LIKE ? ",@userid,"%#{@wbtxt}%"])
      @products = WeiboMain.paginate(:page => params[:page], :per_page => 50, :conditions => ["AccountID = '?' and WeiboText LIKE ? " + @strsql.to_s,@userid,"%#{@wbtxt}%"] )
      @weibomains = @products
    else
      if @strsql != nil then
        @products = WeiboMain.paginate(:page => params[:page], :per_page => 50, :conditions => ["AccountID = '?' and WeiboText LIKE ? " + @strsql,@userid,"%#{@wbtxt}%"] )
        @weibomains = @products
      else
        @products = WeiboMain.paginate(:page => params[:page], :per_page => 50, :conditions => ["AccountID = '?' and WeiboText LIKE ? ",@userid,"%#{@wbtxt}%"] )
        @weibomains = @products
      end
      
    end
    
  end
end
