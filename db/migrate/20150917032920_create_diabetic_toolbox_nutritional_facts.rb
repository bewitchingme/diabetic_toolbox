class CreateDiabeticToolboxNutritionalFacts < ActiveRecord::Migration
  def change
    create_table :diabetic_toolbox_nutritional_facts do |t|
      t.belongs_to :recipe
      t.string     :nutrient
      t.float      :quantity
      t.boolean    :verified, default: false, null: false

      t.timestamps null: false
    end

    add_index :diabetic_toolbox_nutritional_facts, :recipe_id
  end
end
