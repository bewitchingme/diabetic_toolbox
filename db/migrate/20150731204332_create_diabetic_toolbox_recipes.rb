class CreateDiabeticToolboxRecipes < ActiveRecord::Migration
  def change
    create_table :diabetic_toolbox_recipes do |t|
      t.belongs_to :member
      t.string     :name
      t.integer    :servings
      t.integer    :grams_carbohydrate_per_serving
      t.integer    :calories_per_serving
      t.integer    :grams_fat_per_serving
      t.integer    :grams_protein_per_serving

      t.timestamps null: false
    end

    add_index :diabetic_toolbox_recipes, :member_id
  end

  def down
    drop_table :diabetic_toolbox_recipes
  end
end
