class CreateDiabeticToolboxSettings < ActiveRecord::Migration
  def up
    create_table :diabetic_toolbox_settings do |t|
      t.belongs_to :member
      t.integer    :glucometer_measure_type
      t.integer    :intake_measure_type
      t.integer    :intake_ratio
      t.float      :correction_begins_at
      t.integer    :increments_per
      t.integer    :ll_units_per_day

      t.timestamps null: false
    end

    add_index :diabetic_toolbox_settings, :member_id
    add_index :diabetic_toolbox_settings, :glucometer_measure_type
    add_index :diabetic_toolbox_settings, :intake_measure_type
  end

  def down
    drop_table :diabetic_toolbox_settings
  end
end
