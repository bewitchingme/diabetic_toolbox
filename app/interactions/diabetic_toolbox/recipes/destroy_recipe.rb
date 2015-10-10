module DiabeticToolbox
  class DestroyRecipe < Exchange
    #region Init
    def initialize(member, recipe)
      @member = member
      @recipe = recipe
    end
    #endregion

    #region Protected
    def _call
      if can_destroy?
        if @recipe.destroy
          success do |option|
            option.subject = @recipe
            option.message = I18n.t('flash.recipe.destroyed.success')
          end
        else
          failure do |option|
            option.subject = @recipe
            option.message = I18n.t('flash.recipe.destroyed.failure')
          end
        end
      else
        not_allowed! unless member_owns_recipe?
        already_published! unless recipe_not_published?
      end
    end
    #endregion

    #region Private
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

    def can_destroy?
      return true if member_owns_recipe? && recipe_not_published?
    end

    def member_owns_recipe?
      @recipe.owned_by?(@member)
    end

    def recipe_not_published?
      !@recipe.published?
    end
    #endregion
  end
end