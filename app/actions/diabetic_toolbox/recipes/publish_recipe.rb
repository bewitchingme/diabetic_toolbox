module DiabeticToolbox
  rely_on :action

  class PublishRecipe < Action
    #region Init
    def initialize(member, recipe_id)
      super recipe_id
      @member = member
    end
    #endregion

    #region Protected
    def _call
      recipe  = Recipe.find @params
      updated = false
      updated = recipe.update_column(:published, true) if recipe.member.eql? @member

      if updated
        success do |option|
          option.subject = recipe
          option.message = I18n.t('flash.recipe.published.success')
        end
      else
        failure do |option|
          option.subject = recipe
          option.message = I18n.t('flash.recipe.published.failure')
        end
      end
    end
    #endregion
  end
end