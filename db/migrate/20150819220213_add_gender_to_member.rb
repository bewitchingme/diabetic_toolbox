class AddGenderToMember < ActiveRecord::Migration
  def change
    add_column :diabetic_toolbox_members,
               :gender, :integer, after: :dob
    add_column :diabetic_toolbox_members,
               :accepted_tos, :boolean,
               null: false,
               default: false,
               after: :gender
  end

  def down
    remove_column :diabetic_toolbox_members, :gender
    remove_column :diabetic_toolbox_members, :accepted_tos
  end
end
