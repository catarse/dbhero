require 'test_helper'

module Dbhero
  class DataclipsControllerTest < ActionController::TestCase
    setup do
      @dataclip = dataclips(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:dataclips)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create dataclip" do
      assert_difference('Dataclip.count') do
        post :create, dataclip: { description: @dataclip.description, raw_query: @dataclip.raw_query }
      end

      assert_redirected_to dataclip_path(assigns(:dataclip))
    end

    test "should show dataclip" do
      get :show, id: @dataclip
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @dataclip
      assert_response :success
    end

    test "should update dataclip" do
      patch :update, id: @dataclip, dataclip: { description: @dataclip.description, raw_query: @dataclip.raw_query }
      assert_redirected_to dataclip_path(assigns(:dataclip))
    end

    test "should destroy dataclip" do
      assert_difference('Dataclip.count', -1) do
        delete :destroy, id: @dataclip
      end

      assert_redirected_to dataclips_path
    end
  end
end
