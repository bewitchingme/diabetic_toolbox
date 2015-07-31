class CreateDiabeticToolboxReadings < ActiveRecord::Migration
  def change
    create_table :diabetic_toolbox_readings do |t|
      t.belongs_to :patient
      t.float      :glucometer_value
      t.datetime   :time_of_date
      t.integer    :intake

      t.timestamps null: false
    end

    add_index :diabetic_toolbox_readings, :patient_id
  end

  def down
    drop_table :diabetic_toolbox_readings
  end
end
