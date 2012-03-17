class Category < ActiveRecord::Base
  belongs_to(:parent,
             :class_name=>"Category",
             :foreign_key=>"ParentID")
  has_many(:childs,
           :class_name=>"Category",
           :foreign_key=>"ParentID")
end
