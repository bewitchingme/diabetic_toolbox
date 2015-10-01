require_dependency "diabetic_toolbox/application_controller"

module DiabeticToolbox
  class RecipesController < ApplicationController
    #region Class Methods
    load_and_authorize_resource
    respond_to :json, :html
    #endregion

    #region Before Action
    before_action :set_recipe, only: [:edit, :show, :update, :destroy, :finalize]
    before_action :deploy_member_navigation, only: [:index, :new, :edit, :show]
    #endregion

    #region Read
    def index
      if member_signed_in?
        @recipes = Recipe.where(member_id: current_member.id).page( params[:page] )
      else
        @recipes = Recipe.order(:created_at)
      end
    end

    def new
      @recipe = Recipe.new
    end

    def edit
    end

    def show
    end
    #endregion

    #region Creation
    def create
      DiabeticToolbox.from :recipes, require: %w(create_recipe)

      result = CreateRecipe.new(current_member, recipe_params).call

      if result.success?
        flash[:success] = result.flash
        redirect_to edit_recipe_path(result.actual)
      else
        @recipe = result.actual
        flash[:warning] = result.flash
        render :new
      end
    end
    #endregion

    #region Mutation
    def update
      DiabeticToolbox.from :recipes, require: %w(update_recipe)

      result = UpdateRecipe.new( current_member, @recipe, recipe_params ).call

      if result.success?
        flash[:success] = result.flash
        redirect_to edit_recipe_path(result.actual)
      else
        @recipe = result.actual
        flash[:danger] = result.flash
        render :edit
      end
    end

    def finalize
      DiabeticToolbox.from :recipes, require: %w(publish_recipe)

      result = PublishRecipe.new( current_member, @recipe ).call

      if result.success?
        flash[:success] = result.flash
        redirect_to show_recipe_path(result.actual)
      else
        @recipe = result.actual
        flash[:danger] = result.flash
        render :edit
      end
    end

    def destroy
      DiabeticToolbox.from :recipes, require: %w(destroy_recipe)

      result = DestroyRecipe.new( current_member, @recipe ).call

      if result.success?
        flash[:success] = result.flash
        redirect_to recipes_path
      else
        flash[:warning] = result.flash
        redirect_to edit_recipe_path(result.actual)
      end
    end
    #endregion

    #region Private
    def recipe_params
      params.require(:recipe).permit(:name, :servings)
    end

    def set_recipe
      @recipe = Recipe.find params[:id]
    end
    #endregion
  end
end
