module DiabeticToolbox
  # = CreateNutritionalFact
  #
  # This class is used to create a NutritionalFact to be
  # associated with a recipe, as follows:
  #
  #   result = CreateNutritionalFact.new(member, recipe, nutritional_fact_params)
  #
  class CreateNutritionalFact < Exchange
    #:enddoc:
    #region Init
    def initialize(member, recipe, nutritional_fact_params)
      @member, @recipe, @nutritional_fact = member, recipe, recipe.nutritional_facts.new( nutritional_fact_params )
    end
    #endregion

    #region Hooks
    hook :default do
      if can_create?
        if @nutritional_fact.save
          success do |option|
            option.subject = @nutritional_fact
            option.message = I18n.t('flash.nutritional_fact.created.success')
          end
        else
          failure do |option|
            option.subject = @nutritional_fact
            option.message = I18n.t('flash.nutritional_fact.created.failure')
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
        option.subject = @nutritional_fact
        option.message = I18n.t('flash.recipe.common.not_allowed')
      end
    end

    def already_published!
      failure do |option|
        option.subject = @nutritional_fact
        option.message = I18n.t('flash.recipe.common.already_published')
      end
    end

    def can_create?
      member_owns_recipe? && recipe_not_published?
    end

    def member_owns_recipe?
      @recipe.owned_by? @member
    end

    def recipe_not_published?
      !@recipe.published?
    end
    #endregion
  end
end