require 'test_helper'

module DiabeticToolbox
  class MemberSessionControllerTest < ActionController::TestCase
    setup do
      @routes = Engine.routes
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should get create" do
      get :create
      assert_response :success
    end

    test "should get destroy" do
      get :destroy
      assert_response :success
    end

  end
end
