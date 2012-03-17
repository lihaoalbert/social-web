class AddColumnToRuleDef < ActiveRecord::Migration
  def change
    add_column :rule_defs, :RuleType, :integer, :limit => 2
    add_column :rule_defs, :ParentID, :integer, :limit => 11, :null => false
    add_column :rule_defs, :MonitCnt, :integer
  end
end
