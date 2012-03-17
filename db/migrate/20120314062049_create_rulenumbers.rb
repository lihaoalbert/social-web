class CreateRulenumbers < ActiveRecord::Migration
  def change
    create_table :rulenumbers do |t|
      t.column :RuleID, :integer, :null => false
      t.column :RuleNum, :integer, :null => false
      t.timestamps
    end
  end
end
