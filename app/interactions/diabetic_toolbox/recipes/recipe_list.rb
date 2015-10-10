module DiabeticToolbox
  # = RecipeList
  #
  # This class is used to retrieve the list of published recipes as
  # well as recipes that may be owned by the member, used as follows:
  #
  #   list = RecipeList.new(current_member, params[:page])
  #   list.child :recipes #=> Relation of published recipes
  #   list.child :member_recipes #=> Relation of recipes owned by current_member
  #
  class RecipeList
    #:enddoc:
    #region Include
    include List
    #endregion

    #region Init
    def initialize(member = nil, page = nil)
      set_child :member_recipes, Recipe.where(member: member).order(published: :desc) if member.present?
      set_child :recipes,        Recipe.published.order(created_at: :desc).page( page )
    end
    #endregion
  end
end