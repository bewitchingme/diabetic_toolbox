class RemoveMeasurementsFromRecipes < ActiveRecord::Migration
  def change
    change_table :diabetic_toolbox_recipes do |t|
      t.remove :grams_carbohydrate_per_serving, :calories_per_serving, :grams_fat_per_serving, :grams_protein_per_serving
      t.boolean :published
      t.index :published
      t.index :servings
    end
  end
end
