class CreateDiabeticToolboxAchievements < ActiveRecord::Migration
  def change
    create_table :diabetic_toolbox_achievements do |t|
      t.belongs_to :member
      t.string     :name
      t.integer    :points
      t.integer    :level

      t.timestamps null: false
    end

    add_index :diabetic_toolbox_achievements, :member_id
  end

  def down
    drop_table :diabetic_toolbox_achievements
  end
end
