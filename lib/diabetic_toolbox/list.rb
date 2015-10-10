module DiabeticToolbox
  # = DiabeticToolbox::List
  #
  # This module provides methods to allow for flexible list
  # results, used as follows:
  #
  #   class ModelList
  #     include DiabeticToolbox::List
  #
  #     def initialize(args)
  #       set_child :all, Model.all
  #     end
  #   end
  #
  #   list = ModelList.new
  #   list.child :all #=> Relation
  module List
    #:enddoc:
    #region Included methods
    def child(scope)
      @children[scope]
    end

    protected
    def set_child(scope, records)
      @children ||= {}
      @children[scope] = records
    end
    #endregion
  end
end