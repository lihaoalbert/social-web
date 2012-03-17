class CreateProvinceCities < ActiveRecord::Migration
  def change
    create_table :province_cities do |t|
      t.column :NodeClass, :string, :limit =>50
      t.column :Code, :string, :limit =>50
      t.column :ParentCode, :string, :limit =>50
      t.column :Name, :string, :limit =>100
      t.column :Name_En, :string, :limit =>100
      t.timestamps
    end
  end
end
