module DiabeticToolbox
  # = Exchange
  #
  # Exchange is the base for each data exchange performed in the Diabetic Toolbox.  When
  # a class defined which inherits from Exchange, the child is required at minimum
  # to define a hook named :default, though defining no hook will simply result in no work
  # being performed when +call+ is executed.
  #
  # The following is a brief example
  #
  #   class MyExchange < Exchange
  #     def initialize(params)
  #       super params
  #     end
  #
  #     hook :default do
  #       # ...
  #     end
  #   end
  #
  # If there is some necessary preparation to do before the call is made,
  # you should implement the :before hook, as follows:
  #
  #   hook :before do
  #     # ...
  #   end
  #
  # And similarly when there is work to be performed after the call,
  # :after should be implemented:
  #
  #   hook :after do
  #     # ...
  #   end
  class Exchange
    #:enddoc:
    #region Class Methods
    def self.hook(name, &block)
      @hooks ||= {}
      @hooks[name] = block
    end
    #endregion

    #region Public
    def initialize(params)
      @params  = params
      @result  = nil
    end

    def call
      call_hook(:before)
      call_hook(:default)
      call_hook(:after)
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
    #endregion

    #region Private
    private
    def get_hook(name)
      hooks[name] if hook_exists? name
    end

    def hook_exists?(name)
      hooks.has_key? name unless hooks.nil?
    end

    def hooks
      self.class.instance_variable_get(:@hooks)
    end

    def call_hook(name)
      instance_eval &get_hook(name) if hook_exists? name
    end
    #endregion
  end
end