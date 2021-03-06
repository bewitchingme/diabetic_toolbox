require 'rails_helper'

module DiabeticToolbox
  RSpec.describe RecipesController, type: :controller do
    routes { DiabeticToolbox::Engine.routes }

    #region Definitions
    let(:member) { create(:member_with_a_recipe) }
    let(:recipe) { build(:recipe)  }
    #endregion

    #region Member
    describe 'a member' do
      it 'should be able to GET to :index' do
        sign_in_member member

        get :index

        expect(response).to have_http_status 200
        expect(assigns(:recipes)).to be_a ActiveRecord::Relation
      end

      it 'should be able to GET to :new' do
        sign_in_member member

        get :new

        expect(response).to have_http_status 200
        expect(assigns(:recipe)).to be_a Recipe
      end

      it 'should be able to POST to :create' do
        sign_in_member member

        post :create, recipe: {name: recipe.name, servings: recipe.servings}
        new_recipe = member.recipes.last

        expect(response).to have_http_status 302
        expect(response).to redirect_to edit_recipe_path(new_recipe)
      end

      it 'should be able to GET to :edit' do
        sign_in_member member

        get :edit, id: member.recipes.first.id

        expect(response).to have_http_status 200
        expect(assigns(:recipe)).to be_a Recipe
      end

      it 'should be able to PATCH to :update' do
        sign_in_member member

        patch :update, id: member.recipes.first.id, recipe: { name: "#{member.recipes.first.name}1" }

        expect(response).to have_http_status 302
        expect(response).to redirect_to edit_recipe_path(member.recipes.first)
      end

      it 'should be able to DELETE to :destroy' do
        sign_in_member member

        delete :destroy, id: member.recipes.first.id

        expect(response).to have_http_status 302
        expect(response).to redirect_to recipes_path
      end

      it 'should be able to PATCH to :finalize' do
        sign_in_member member

        patch :finalize, id: member.recipes.first.id
        member.recipes.first.reload

        expect(response).to have_http_status 302
        expect(response).to redirect_to show_recipe_path(member.recipes.first)
        expect(member.recipes.first.published?).to eq true
      end
    end
    #endregion

    #region Visitor
    describe 'a visitor' do
      it 'should be able to GET to :index' do
        get :index

        expect(response).to have_http_status 200
        expect(assigns(:recipes)).to be_a ActiveRecord::Relation
      end

      it 'should be able to GET to :show' do
        recipe.save

        get :show, id: recipe.id

        expect(response).to have_http_status 200
        expect(assigns(:recipe)).to be_a Recipe
      end
    end
    #endregion
  end
end
