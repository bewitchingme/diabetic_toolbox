module DiabeticToolbox
  class CreateRecipe < Exchange
    #region Init
    def initialize(member, recipe_params)
      super recipe_params
      @recipe = member.recipes.new @params
    end
    #endregion

    #region Protected
    def _call
      if @recipe.save
        success do |option|
          option.subject = @recipe
          option.message = I18n.t('flash.recipe.created.success', recipe_name: @recipe.name)
        end
      else
        failure do |option|
          option.subject = @recipe
          option.message = I18n.t('flash.recipe.created.failure')
        end
      end
    end
    #endregion
  end
end