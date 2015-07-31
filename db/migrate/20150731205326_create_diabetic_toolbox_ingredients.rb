class CreateDiabeticToolboxIngredients < ActiveRecord::Migration
  def change
    create_table :diabetic_toolbox_ingredients do |t|
      t.belongs_to :recipe
      t.string     :name
      t.float      :volume
      t.integer    :unit

      t.timestamps null: false
    end

    add_index :diabetic_toolbox_ingredients, :recipe_id
  end

  def down
    drop_table :diabetic_toolbox_ingredients
  end
end
