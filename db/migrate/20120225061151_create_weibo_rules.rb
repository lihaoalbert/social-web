class CreateWeiboRules < ActiveRecord::Migration
  def change
    create_table :weibo_rules do |t|
      t.column :WeiboID, :string, :limit => 30, :null => false                  #微博ID
      t.column :RuleID, :integer, :null => false                                #规则ID
      t.column :WeiboTime, :datetime, :null => false                            #微博时间
      t.column :WeiboFrom, :integer, :null => false                             #微博渠道
      
      t.timestamps
    end
    add_index :weibo_rules, [:WeiboID,:RuleID],           :unique => true
  end
end
