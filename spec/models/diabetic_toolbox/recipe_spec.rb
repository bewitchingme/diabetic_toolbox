require 'rails_helper'

module DiabeticToolbox
  RSpec.describe Recipe, type: :model do
    #region Definitions
    let(:recipe) { build(:recipe) }
    let(:recipe_create_failure_flash) { 'Sorry, your recipe could not be saved' }
    #endregion

    #region Stories
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
              name:     random_string(65),
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

      #region Mutation
      context 'being updated using action class' do
        DiabeticToolbox.from :recipes, require: %w(create_recipe publish_recipe update_recipe)

        it 'should be published by the creating member' do
          member = create(:member)
          recipe_params = {
              name: recipe.name,
              servings: recipe.servings
          }

          create_result = CreateRecipe.new( member, recipe_params ).call
          recipe_to_publish = create_result.actual

          publish_result = PublishRecipe.new( member, recipe_to_publish ).call

          expect(publish_result.success?).to eq true
          expect(publish_result.flash).to eq 'Recipe has been published'
          expect(publish_result.response).to eq ['Recipe has been published', {}, {name: recipe_to_publish.name, servings: recipe_to_publish.servings}]
          expect(publish_result.actual.published).to eq true
        end

        it 'should be updated by the creating member when the recipe is not published' do
          member           = create(:member)
          recipe.member_id = member.id

          recipe.save

          recipe_params = {
              name: 'John\'s Tubers',
              servings: recipe.servings
          }

          result = UpdateRecipe.new( member, recipe, recipe_params ).call

          expect(result.success?).to eq true
          expect(result.flash).to eq 'Recipe has been saved'
          expect(result.response).to eq ['Recipe has been saved', {}, {name: 'John\'s Tubers', servings: recipe.servings}]
        end

        it 'should not be updated by the creating member when the recipe is published' do
          member           = create(:member)
          recipe.member_id = member.id
          recipe.published = true

          recipe.save

          recipe_params = {
              name: 'John\'s Tubers',
              servings: recipe.servings
          }

          result = UpdateRecipe.new( member, recipe, recipe_params ).call

          expect(result.success?).to eq false
          expect(result.flash).to eq 'Sorry, this recipe is published and cannot be changed'
          expect(result.response).to eq ['Sorry, this recipe is published and cannot be changed', {}, {name: recipe.name, servings: recipe.servings}]
        end

        it 'should not be updated if the recipe is owned by another member' do
          member           = create(:member)
          updating_member  = create(:member)
          recipe.member_id = member.id

          recipe.save

          recipe_params = {
              name: 'John\'s Tubers',
              servings: recipe.servings
          }

          result = UpdateRecipe.new( updating_member, recipe, recipe_params ).call

          expect(result.success?).to eq false
          expect(result.flash).to eq 'Sorry, you must own the recipe to do that'
          expect(result.response).to eq ['Sorry, you must own the recipe to do that', {}, {name: recipe.name, servings: recipe.servings}]
        end
      end
      #endregion

      #region Destruction
      context 'being destroyed using action class' do
        DiabeticToolbox.from :recipes, require: %w(destroy_recipe)
        it 'should be destroyed if the recipe is not published' do
          member           = create(:member)
          recipe.member_id = member.id
          recipe.save

          result = DestroyRecipe.new( member, recipe ).call

          expect(result.success?).to eq true
          expect(result.flash).to eq 'Your recipe has been deleted'
        end

        it 'should not be destroyed if the recipe is published' do
          member           = create(:member)
          recipe.member_id = member.id
          recipe.published = true

          recipe.save

          result = DestroyRecipe.new( member, recipe ).call

          expect(result.success?).to eq false
          expect(result.flash).to eq 'Sorry, this recipe is published and cannot be changed'
        end

        it 'should not be destroyed if it is member is not the owner' do
          member             = create(:member)
          destructive_member = create(:member)

          recipe.member_id = member.id
          recipe.save

          result = DestroyRecipe.new( destructive_member, recipe ).call

          expect(result.success?).to eq false
          expect(result.flash).to eq 'Sorry, you must own the recipe to do that'
        end
      end
      #endregion
    end
    #endregion
  end
end
