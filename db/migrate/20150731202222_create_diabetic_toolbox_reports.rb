class CreateDiabeticToolboxReports < ActiveRecord::Migration
  def change
    create_table :diabetic_toolbox_reports do |t|
      t.belongs_to :patient
      t.string :name
      t.datetime :coverage_start
      t.datetime :coverage_end

      t.timestamps null: false
    end

    add_index :diabetic_toolbox_reports, :patient_id
  end

  def down
    drop_table :diabetic_toolbox_reports
  end
end
