module DiabeticToolbox
  class PublishRecipe < Exchange
    #region Init
    def initialize(member, recipe)
      super nil
      @recipe = recipe
      @member = member
    end
    #endregion

    #region Protected
    def _call
      updated = false
      updated = @recipe.update_column(:published, true) if @recipe.owned_by? @member

      if updated
        success do |option|
          option.subject = @recipe
          option.message = I18n.t('flash.recipe.published.success')
        end
      else
        failure do |option|
          option.subject = @recipe
          option.message = I18n.t('flash.recipe.published.failure')
        end
      end
    end
    #endregion
  end
end