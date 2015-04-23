require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get support" do
    get :support
    assert_response :success
  end

  test "should get import" do
    get :import
    assert_response :success
  end

  test "should get export" do
    get :export
    assert_response :success
  end

end
