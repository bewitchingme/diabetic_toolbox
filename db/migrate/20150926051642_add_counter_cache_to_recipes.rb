class AddCounterCacheToRecipes < ActiveRecord::Migration
  def change
    add_column :diabetic_toolbox_recipes, :steps_count,             :integer, null: false, default: 0
    add_column :diabetic_toolbox_recipes, :ingredients_count,       :integer, null: false, default: 0
    add_column :diabetic_toolbox_recipes, :nutritional_facts_count, :integer, null: false, default: 0
  end
end
