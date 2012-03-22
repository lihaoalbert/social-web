class JobRuleNumber
  @queue = :webo_jobs
  def self.perform
    database = YAML.load_file(File.join(Rails.root.to_s, 'config', 'database.yml'))[Rails.env || "development"]
    dbh = Mysql2::Client.new(:host => database["host"],:username => database["username"],:password => database["password"])
    dbh.query("USE `#{database['database']}`;")
    dbh.query('set names utf8;');
    #删除近60天数据
    sql = "delete from rulenumbers where date(created_at) 
      >= date(DATE_ADD(now(),INTERVAL -60 DAY))"
      # >= '" + Time.new.strftime("%Y-%m-%d") + "'" 
    dbh.query(sql)
    #重新插入近60天数据
    sql = "insert into rulenumbers(RuleID, RuleNum, created_at) 
    select a.RuleID,count(a.WeiboID), date(b.WeiboTime) from weibo_rules a 
    left join weibo_mains b on a.WeiboID=b.WeiboID 
    where date(b.WeiboTime) >= date(DATE_ADD(now(),INTERVAL -60 DAY))
    group by a.RuleID, date(b.WeiboTime)"
    
    # select now(), date(now()),  DATE_ADD(now(),INTERVAL 14 DAY) 
    dbh.query(sql)
    dbh.close
    #date_range 日期列表
    date_range = Rulenumber.find(:all, 
      :select => "created_at",
      :conditions => ["created_at >= date(DATE_ADD(now(),INTERVAL -60 DAY))"],
      :group => "created_at")
    treeall = RuleDef.find(:all, :conditions => ["RuleType = 1"])
    treeall.each do |t|
      if RuleDef.count(:conditions => ["ParentID = ?", t.id]) == 0 then
        date_range.each do |d|
          AddParent.new.addparent(t.id,d.created_at)
        end
      end
    end
    #汇总全部记录数据，更新到RuleDef
    rnall = Rulenumber.find(:all, 
      :select => "RuleID,sum(RuleNum) as RuleNum",
      :group => "RuleID")
    rnall.each do |r|
      if RuleDef.count(:conditions => ["id = ?", r.RuleID]) > 0  then
        RuleDef.update(r.RuleID,{:MonitCnt => r.RuleNum})
      end
    end
  end
end
class AddParent
  def addparent(ruleid,date)
    @parentid = RuleDef.find(ruleid).ParentID ? RuleDef.find(ruleid).ParentID : -1
    if @parentid != -1 then
      @parent = Rulenumber.find(:all,:conditions => ["created_at = ? and RuleID = ?",date,@parentid])
      @sun = Rulenumber.find(:all,:conditions => ["created_at = ? and RuleID = ?",date,ruleid])
      @count = @sun[0].RuleNum.to_i + @parent[0].RuleNum.to_i
      Rulenumber.update(@parent[0].id,{:RuleNum => @count})
      addparent(@parentid,date)
    end
  end
end