class CreateDiabeticToolboxReportConfigurations < ActiveRecord::Migration
  def change
    create_table :diabetic_toolbox_report_configurations do |t|
      t.belongs_to :member
      t.string     :name
      t.integer    :period
      t.date       :from
      t.date       :to

      t.timestamps null: false
    end

    add_index :diabetic_toolbox_report_configurations, :member_id
  end

  def down
    drop_table :diabetic_toolbox_report_configurations
  end
end
