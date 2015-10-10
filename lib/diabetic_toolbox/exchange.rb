module DiabeticToolbox
  # = Exchange
  #
  # Exchange is the base for each data exchange performed in the Diabetic Toolbox.  When
  # a class defined which inherits from Exchange, the child is required at minimum
  # to redefine +_call+ which carries out the necessary work to perform the exchange.
  #
  # The following is a brief example
  #
  #   class MyExchange < Exchange
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
  class Exchange
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

    def call_params
      @params
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