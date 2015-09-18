class AddLocaleToMembers < ActiveRecord::Migration
  def change
    add_column :diabetic_toolbox_members, :locale, :integer, null: false, default: 0
  end
end
