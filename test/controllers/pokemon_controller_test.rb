require "test_helper"

class PokemonControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pokemon_index_url
    assert_response :success
  end

  test "should get capture" do
    get pokemon_capture_url
    assert_response :success
  end

  test "should get captured" do
    get pokemon_captured_url
    assert_response :success
  end

  test "should get destroy" do
    get pokemon_destroy_url
    assert_response :success
  end

  test "should get import" do
    get pokemon_import_url
    assert_response :success
  end
end
