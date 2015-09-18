class AddTimeZoneToMembers < ActiveRecord::Migration
  def change
    add_column :diabetic_toolbox_members, :time_zone, :string, null: false, default: 'UTC'
  end
end
