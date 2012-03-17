class CreateJobArgs < ActiveRecord::Migration
  def change
    create_table :job_args do |t|
      t.column :ArgsClass, :string, :limit => 20, :null => false
      t.column :ArgsName, :string, :limit => 20
      t.column :ArgsValue, :string, :limit => 100

      t.timestamps
    end
    add_index :job_args, [:ArgsClass,:ArgsName], :unique => true
  end
end
