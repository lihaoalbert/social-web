class JobDeleteStage
  @queue = :webo_jobs
  def self.perform
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
           `WeiboText`,
           `WeiboTime`,
           `WeiboSource`,
           `WeiboUID`,
           `ScreenName`,
           left(`UserLocation`, locate(' ', `UserLocation`)) as `Province`,
           substring(`UserLocation`,locate(' ', `UserLocation`)+1) as `City`,
           `Profile_image_url`,
           `Gender`,
           `Followers_count`,
           `Friends_count`,
           `Statuses_coun`,
           `Verified`,
           `RetweetedID`,
           `AccountID`,
           `WeiboFrom`, now() from weibo_stages 
           where created_at < DATE_ADD(now(),INTERVAL -600 SECOND)
              and WeiboID not in(select distinct WeiboID from weibo_mains)"
    dbh.query(sql)
    sql = "insert into weibo_rules (WeiboID, RuleID, WeiboTime, WeiboFrom, created_at)
           select distinct WeiboID, RuleID, WeiboTime, 
             case when WeiboFrom='sinaweibo' then 1 else 0 end as WeiboFrom , 
             DATE_ADD(now(),INTERVAL -600 SECOND) as created_at
            from weibo_stages 
             where created_at < DATE_ADD(now(),INTERVAL -600 SECOND)"
    dbh.query(sql)
    sql = "delete from weibo_stages 
           where WeiboID in (select WeiboID from weibo_rules)
           and created_at < (select max(created_at)  from weibo_rules)"
    dbh.query(sql)
    dbh.close
  end
end