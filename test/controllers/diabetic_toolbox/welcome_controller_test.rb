require 'test_helper'

module DiabeticToolbox
  class WelcomeControllerTest < ActionController::TestCase
    setup do
      @routes = Engine.routes
    end

    test "should get start" do
      get :start
      assert_response :success
    end

  end
end
