class ReportData
  @data = Array.new
  @xAxis = Array.new
  @yAxis = Array.new
  def initialize(data_from)
    rule = Array.new
    rule = data_from.sort_by{|x| x}
    ruleone = rule[0][0]
    rule.each do |y|
      if y[0] == ruleone then
        @yAxis.push(y[2])
        @xAxis.push(y[1])
      else
        @data.push([ruleone, @yAxis])
        @yAxis = Array.new
        @yAxis.push(y[2])
        ruleone = y[0]
        @xAxis.push(y[1])
      end
    end
    @data.push([ruleone, @yAxis])
  end

  def get_report_xAxis
    #return @xAxis.uniq.sort_by{|x| x}
  end
end