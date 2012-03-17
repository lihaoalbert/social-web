class JobRuleDef
  @queue = :webo_jobs
  def self.perform
    @ruledef = RuleDef.find(:all, :conditions => ["RuleType = ? ",1 ])
    @ruledef.each do |ruledef|
      @num = JobArgs.count(:conditions => {:ArgsName => ruledef.id.to_s, :ArgsClass => 'LastRunTime'})
      if @num == 0 then
        JobArgs.create({
          :ArgsName => ruledef.id.to_s, 
          :ArgsClass => 'LastRunTime', 
          :ArgsValue => Time.mktime(2012,02,1).to_i
        })
      end
      @jobargs = JobArgs.find(:first, :conditions => {:ArgsName => ruledef.id.to_s, :ArgsClass => 'LastRunTime'})
      Resque.enqueue(JobWeiboStage, ruledef.AccountID,ruledef.id,ruledef.KeyWord,ruledef.FilterOri,@jobargs.ArgsValue,@jobargs.id)
    end
  end
end