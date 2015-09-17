require 'rails_helper'

module DiabeticToolbox
  RSpec.describe Recipe, type: :model do
    #region Definitions
    let(:recipe) { build(:recipe) }
    #endregion

    describe 'a recipe' do
      #region Creation
      context 'being created using action class' do
        #region Success
        it 'should be saved with appropriate parameters' do
          DiabeticToolbox.from :recipes, require: %w(create_recipe)
          member = create(:member)
          recipe_params = {
              name: recipe.name,
              servings: recipe.servings
          }
          result = CreateRecipe.new( member, recipe_params ).call

          expect(result.success?).to eq true
          expect(result.actual.published?).to eq false
        end
        #endregion
      end
      #endregion
    end
  end
end
