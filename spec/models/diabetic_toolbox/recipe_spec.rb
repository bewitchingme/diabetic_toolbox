require 'rails_helper'

module DiabeticToolbox
  RSpec.describe Recipe, type: :model do
    #region Definitions
    let(:recipe) { build(:recipe) }
    let(:recipe_create_failure_flash) { 'Sorry, your recipe could not be saved' }
    #endregion

    describe 'a recipe' do
      #region Creation
      DiabeticToolbox.from :recipes, require: %w(create_recipe)
      context 'being created using action class' do
        #region Success
        it 'should be saved with appropriate parameters' do
          member = create(:member)
          recipe_params = {
              name: recipe.name,
              servings: recipe.servings
          }
          result = CreateRecipe.new( member, recipe_params ).call

          expect(result.success?).to eq true
          expect(result.actual.published?).to eq false
          expect(result.flash).to eq "Recipe #{recipe.name} created"
        end
        #endregion

        #region Failure
        it 'should not save when name is too long' do
          member = create(:member)

          recipe_params = {
              name:     random_string(64),
              servings: recipe.servings
          }

          result = CreateRecipe.new( member, recipe_params ).call

          expect(result.success?).to eq false
          expect(result.actual.new_record?).to eq true
          expect(result.flash).to eq recipe_create_failure_flash
        end

        it 'should not save when name is too short' do
          member = create(:member)

          recipe_params = {
              name:     random_string(3),
              servings: recipe.servings
          }

          result = CreateRecipe.new( member, recipe_params ).call

          expect(result.success?).to eq false
          expect(result.actual.new_record?).to eq true
          expect(result.flash).to eq recipe_create_failure_flash
        end

        it 'should not save when servings is set to 0' do
          member = create(:member)

          recipe_params = {
              name: recipe.name,
              servings: 0
          }

          result = CreateRecipe.new( member, recipe_params ).call

          expect(result.success?).to eq false
          expect(result.actual.new_record?).to eq true
          expect(result.flash).to eq recipe_create_failure_flash
        end
        #endregion
      end
      #endregion
    end
  end
end
