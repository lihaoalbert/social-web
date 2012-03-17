class AccountsController < ApplicationController
  def index
  end
  #关系管理
  def following
    if user_signed_in?
      @userid = current_user.id
    else
      #@userid = 1
      redirect_to :controller => 'home'
    end
  end
  
  #推荐客户
  def recommend
    if user_signed_in?
      @userid = current_user.id
    else
      #@userid = 1
      redirect_to :controller => 'home'
    end
  end
  
  #潜客规则设置
  def recommend_setting
    if user_signed_in?
      @userid = current_user.id
    else
      #@userid = 1
      redirect_to :controller => 'home'
    end
  end

end
