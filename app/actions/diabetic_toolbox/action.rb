module DiabeticToolbox
  rely_on :result

  class Action
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

    protected
    def success(&block)
      @result = Result.success &block
    end

    def failure(&block)
      @result = Result.failure &block
    end

    ##
    # The following are to be implemented in the extending
    # classes and are defined only to ensure that any method
    # not implemented still has an endpoint
    #
    def _call ; end

    def _before_call ; end

    def _after_call ; end
  end
end