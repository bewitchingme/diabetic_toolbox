module DiabeticToolbox
  # = PublishRecipe
  #
  # This class is used to publish an unpublished recipe,
  # used as follows:
  #
  #   result = PublishRecipe(member, recipe).call
  #
  class PublishRecipe < Exchange
    #:enddoc:
    #region Init
    def initialize(member, recipe)
      @recipe = recipe
      @member = member
    end
    #endregion

    #region Hooks
    hook :default do
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