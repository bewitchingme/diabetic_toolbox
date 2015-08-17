module Warden
  # Warden::Test::ControllerHelpers provides a facility to test controllers in isolation
  # Most of the code was extracted from Devise's Devise::TestHelpers.
  module Test
    module ControllerHelpers
      def self.included(base)
        base.class_eval do
          setup :setup_controller_for_warden, :warden if respond_to?(:setup)
        end
      end

      # Override process to consider warden.
      def process(*)
        # Make sure we always return @response, a la ActionController::TestCase::Behavior#process, even if warden interrupts
        _catch_warden {super} || @response
      end

      # We need to setup the environment variables and the response in the controller
      def setup_controller_for_warden
        @request.env['action_controller.instance'] = @controller
      end

      # Quick access to Warden::Proxy.
      def warden
        @request.env['warden'] ||= begin
          manager = Warden::Manager.new(nil) do |config|
            config.failure_app        = DiabeticToolbox::UnauthorizedController
            config.default_scope      = :member
            config.intercept_401      = :false

            config.scope_defaults :member, strategies: [:standard]
          end

          Warden::Manager.serialize_from_session(:member) do |token|
            DiabeticToolbox::Member.find_by_session_token token
          end

          Warden::Manager.serialize_into_session(:member) do |member|
            member.session_token
          end

          Warden::Proxy.new(@request.env, manager)
        end
      end

      protected

      # Catch warden continuations and handle like the middleware would.
      # Returns nil when interrupted, otherwise the normal result of the block.
      def _catch_warden(&block)
        result = catch(:warden, &block)

        if result.is_a?(Hash) && !warden.custom_failure? && !@controller.send(:performed?)
          result[:action] ||= :unauthenticated

          env = @controller.request.env
          env['PATH_INFO'] = "/#{result[:action]}"
          env['warden.options'] = result
          Warden::Manager._run_callbacks(:before_failure, env, result)

          status, headers, body = warden.config[:failure_app].call(env).to_a
          @controller.send :render, :status => status, :text => body,
                           :content_type => headers['Content-Type'], :location => headers['Location']

          nil
        else
          result
        end
      end
    end
  end
end