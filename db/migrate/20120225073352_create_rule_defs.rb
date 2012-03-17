class CreateRuleDefs < ActiveRecord::Migration
  def change
    create_table :rule_defs do |t|
      t.column :AccountID, :integer, :limit => 10, :null => false
      t.column :RuleName, :string, :limit => 100, :null => false
      t.column :KeyWord, :string, :limit => 255
      t.column :UserName, :string, :limit => 255
      t.column :FilterOri, :integer, :limit => 10
      t.timestamps
    end
    add_index :rule_defs, :AccountID,            :unique => true
  end
end
