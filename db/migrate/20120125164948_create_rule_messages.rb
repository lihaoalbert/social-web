class CreateRuleMessages < ActiveRecord::Migration
  def change
    create_table :rule_messages do |t|
      t.column :user_id, :integer, :limit => 10, :null => false
      t.column :rulename, :string, :limit => 100, :null => false
      t.column :keyword, :string, :limit => 255
      t.column :username, :string, :limit => 255
      t.column :filterori, :integer, :limit => 10
      t.timestamps
    end
    add_index :rule_messages, :rule_id,            :unique => true
  end
end
