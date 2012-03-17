class RuleDef < ActiveRecord::Base
    belongs_to(:parent,
             :class_name=>"RuleDef",
             :foreign_key=>"ParentID")
  has_many(:childs,
           :class_name=>"RuleDef",
           :foreign_key=>"ParentID")
end
