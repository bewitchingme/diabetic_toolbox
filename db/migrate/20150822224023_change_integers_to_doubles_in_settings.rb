class ChangeIntegersToDoublesInSettings < ActiveRecord::Migration
  def change
    change_column :diabetic_toolbox_settings, :intake_ratio,   :float
    change_column :diabetic_toolbox_settings, :increments_per, :float
  end

  def down
    change_column :diabetic_toolbox_settings, :intake_ratio,   :integer
    change_column :diabetic_toolbox_settings, :increments_per, :integer
  end
end
