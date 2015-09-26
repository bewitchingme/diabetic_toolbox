require 'rails_helper'

module DiabeticToolbox
  RSpec.describe NutritionalFact, type: :model do
    #region Definitions
    let(:member)      { create(:member_with_a_recipe) }
    let(:busy_member) { create(:member_with_a_published_recipe) }
    #endregion

    #region Stories
    describe 'a member' do
      #region Little Helper
      def safe_response(params)
        safe_values = params.dup
        safe_values[:nutrient] = safe_values[:nutrient].to_s
        safe_values
      end
      #endregion

      #region Creation
      context 'creating a nutritional fact using action class' do
        DiabeticToolbox.from :nutritional_facts, require: %w(create_nutritional_fact)
        #region Success
        it 'should be created with appropriate parameters' do
          params = attributes_for(:nutritional_fact)
          result = CreateNutritionalFact.new(member, member.recipes.first, params).call

          expect(result.success?).to eq true
          expect(result.flash).to eq 'Fact Added'
          expect(result.response).to eq ['Fact Added', {}, safe_response(params)]
          expect(member.recipes.first.nutritional_facts.size).to eq 1
        end
        #endregion

        #region Failure
        it 'should not be created with illegal nutrient' do
          params = attributes_for(:nutritional_fact, nutrient: :foo_bar)
          result = CreateNutritionalFact.new(member, member.recipes.first, params).call

          expect(result.success?).to eq false
          expect(result.flash).to eq 'Error: Could not save nutritional fact'
          expect(result.response).to eq ['Error: Could not save nutritional fact', {nutrient: ['Illegal value']}, safe_response(params)]
        end

        it 'should not be created with zero quantity' do
          params = attributes_for(:nutritional_fact, quantity: 0)
          result = CreateNutritionalFact.new(member, member.recipes.first, params).call

          expect(result.success?).to eq false
          expect(result.flash).to eq 'Error: Could not save nutritional fact'
          expect(result.response).to eq ['Error: Could not save nutritional fact', {quantity: ['Must be a non-zero value']}, safe_response(params)]
        end

        it 'should not be created with positive verification' do
          params = attributes_for(:nutritional_fact, verified: true)
          result = CreateNutritionalFact.new(member, member.recipes.first, params).call

          expect(result.success?).to eq false
          expect(result.flash).to eq 'Error: Could not save nutritional fact'
          expect(result.response).to eq ['Error: Could not save nutritional fact', {verified: ['Cannot be verified when created']}, safe_response(params)]
        end

        it 'should not be created by a member that does not own the recipe' do
          params = attributes_for(:nutritional_fact)
          result = CreateNutritionalFact.new(busy_member, member.recipes.first, params).call

          expect(result.success?).to eq false
          expect(result.flash).to eq 'Sorry, you must own the recipe to do that'
          expect(result.response).to eq ['Sorry, you must own the recipe to do that', {}, safe_response(params)]
        end

        it 'should not be created if the recipe is already published' do
          params = attributes_for(:nutritional_fact)
          result = CreateNutritionalFact.new(busy_member, busy_member.recipes.first, params).call

          expect(result.success?).to eq false
          expect(result.flash).to eq 'Sorry, this recipe is published and cannot be changed'
          expect(result.response).to eq ['Sorry, this recipe is published and cannot be changed', {}, safe_response(params)]
        end
        #endregion
      end
      #endregion

      #region Verification
      #endregion

      #region Destruction
      #endregion
    end
    #endregion
  end
end
