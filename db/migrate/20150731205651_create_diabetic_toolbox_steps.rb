class CreateDiabeticToolboxSteps < ActiveRecord::Migration
  def change
    create_table :diabetic_toolbox_steps do |t|
      t.belongs_to :recipe
      t.string :description
      t.integer :order

      t.timestamps null: false
    end

    add_index :diabetic_toolbox_steps, :recipe_id
  end

  def down
    drop_table :diabetic_toolbox_steps
  end
end
