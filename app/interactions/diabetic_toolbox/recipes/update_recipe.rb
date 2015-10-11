module DiabeticToolbox
  class UpdateRecipe < Exchange
    #region Init
    def initialize(member, recipe, recipe_params)
      super recipe_params
      @member = member
      @recipe = recipe
    end
    #endregion

    #region Hooks
    hook :default do
      if can_update?
        if @recipe.update call_params
          success do |option|
            option.subject = @recipe
            option.message = I18n.t('flash.recipe.updated.success')
          end
        else
          failure do |option|
            option.subject = @recipe
            option.message = I18n.t('flash.recipe.updated.failure')
          end
        end
      else
        not_allowed! unless member_owns_recipe?
        already_published! unless recipe_not_published?
      end
    end
    #endregion

    #region Private
    private
    def not_allowed!
      failure do |option|
        option.subject = @recipe
        option.message = I18n.t('flash.recipe.common.not_allowed')
        option.unsafe!
      end
    end

    def already_published!
      failure do |option|
        option.subject = @recipe
        option.message = I18n.t('flash.recipe.common.already_published')
      end
    end

    def member_owns_recipe?
      @recipe.owned_by? @member
    end

    def recipe_not_published?
      !@recipe.published?
    end

    def can_update?
      member_owns_recipe? && recipe_not_published?
    end
    #endregion
  end
end
