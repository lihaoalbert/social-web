class CreateUploadMessages < ActiveRecord::Migration
  def change
    create_table :upload_messages do |t|
      t.column :user_id, :integer, :limit => 10
      t.column :message, :string, :limit => 255
      t.column :image, :string, :limit => 255
	    t.column :uploadtime, :datetime
	    t.column :username, :string, :limit => 255
	    t.column :isselected, :boolean
	    t.column :weibo_firm, :string, :limit => 50
	    t.column :Wbid, :integer, :limit => 19
	    t.column :monitor, :boolean

      t.timestamps
    end
  end
end
