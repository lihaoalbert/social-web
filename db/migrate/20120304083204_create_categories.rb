class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.column :Name, :string, :limit => 50, :null => false
      t.column :Url, :string, :limit => 50, :null => false
      t.column :ParentID, :integer
      t.timestamps
    end
  end
end
