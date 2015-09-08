module DiabeticToolbox
  rely_on :result

  # = Action
  #
  # Action is the base for each action taken in the Diabetic Toolbox.  When
  # a class defined which inherits from Action, the child is required at minimum
  # to redefine +_call+ which carries out the necessary work to perform the action.
  #
  # The following is a brief example
  #
  #   class MyAction < Action
  #     def initialize(params)
  #       super params
  #     end
  #
  #     protected
  #     def _call
  #       # ...
  #     end
  #   end
  #
  # If there is some necessary preparation to do before the call is made,
  # you should implement +_before_call+ as follows:
  #
  #   protected
  #   def _before_call
  #     # ...
  #   end
  #
  # And similarly when there is work to be performed after the call,
  # +_after_call+ should be defined:
  #
  #   protected
  #   def _after_call
  #     # ...
  #   end
  class Action
    #:enddoc:

    #region Public
    def initialize(params)
      @params  = params
      @result  = nil
    end

    def call
      _before_call
      _call
      _after_call
      @result
    end
    #endregion

    #region Protected
    protected
    def call_result
      @result
    end

    def success(&block)
      @result = Result.success &block
    end

    def failure(&block)
      @result = Result.failure &block
    end

    def _call ; end

    def _before_call ; end

    def _after_call ; end
    #endregion
  end
end