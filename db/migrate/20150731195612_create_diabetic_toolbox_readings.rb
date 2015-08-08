class CreateDiabeticToolboxReadings < ActiveRecord::Migration
  def change
    create_table :diabetic_toolbox_readings do |t|
      t.belongs_to :member
      t.float      :glucometer_value
      t.datetime   :test_time
      t.integer    :meal
      t.integer    :intake

      t.timestamps null: false
    end

    add_index :diabetic_toolbox_readings, :member_id
    add_index :diabetic_toolbox_readings, :glucometer_value
    add_index :diabetic_toolbox_readings, :test_time
    add_index :diabetic_toolbox_readings, :meal
  end

  def down
    drop_table :diabetic_toolbox_readings
  end
end
