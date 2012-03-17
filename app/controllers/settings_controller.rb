class SettingsController < ApplicationController
  #数据监听
  def keyword_rule_list
    if user_signed_in?
      @userid = current_user.id
    else
      #@userid = 1
      redirect_to :controller => 'home'
    end
    @ruledef = RuleDef.find(:all, :conditions => ["AccountID = '?' and RuleType <> ? ",@userid,0 ] )
  end
  
  #数据监听新增
  def keyword_rule_new
    if user_signed_in?
      @userid = current_user.id
    else
      #@userid = 1
      redirect_to :controller => 'home'
    end
    @ruledef = RuleDef.find(:all, :conditions => ["AccountID = '?' and RuleType <> ? ",@userid,0 ] )
    @rulemessage = RuleDef.new
  end
  
  #数据监听规则修改
  def keyword_rule_edit
    if user_signed_in?
      @userid = current_user.id
    else
      #@userid = 1
      redirect_to :controller => 'home'
    end
    @ruledef = RuleDef.find(:all, :conditions => ["AccountID = '?' and RuleType <> ? ",@userid,0 ] )
    ruleid = params[:id]
    @rulemessage = RuleDef.find(ruleid)
    
  end
  
  #规则保存
  def rule_save
    if user_signed_in?
      @userid = current_user.id
    else
      #@userid = 1
      redirect_to :controller => 'home'
    end
    ruleid = params[:id]
    rulename = params[:rulename]
    keyword = params[:keyword]
    filterori = params[:filterori]
    if ruleid == "" || ruleid == nil then
      RuleDef.create({
      :AccountID => @userid, 
      :RuleName => rulename,
      :KeyWord => keyword, 
      :UserName => nil, 
      :FilterOri => filterori, 
      :RuleType => 1
    })
    else
      RuleDef.update(ruleid,{
      :AccountID => @userid, 
      :RuleName => rulename, 
      :KeyWord => keyword, 
      :UserName => nil, 
      :FilterOri => filterori
    })
    end
    redirect_to :action => 'keyword_rule_list'
  end
  
  #规则删除
  def rule_delete
    ruleid = params[:id]
    ruletype = params[:typeid].to_i
    RuleDef.update(ruleid,{:RuleType => 0})
    case ruletype
    when 1
      RuleDef.update(ruleid,{:RuleType => 2})
    when 2
      RuleDef.update(ruleid,{:RuleType => 1})
    when 0
      RuleDef.update(ruleid,{:RuleType => 0})
    end
    redirect_to :action => 'keyword_rule_list'
  end
  
end