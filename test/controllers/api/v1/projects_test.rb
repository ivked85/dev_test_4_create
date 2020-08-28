require 'test_helper'

module API::V1
  class Projects::APITest < ActiveSupport::TestCase
    include Rack::Test::Methods

    def app
      Rails.application
    end

    test 'index returns an array of serialized projects' do
      get '/api/v1/projects'
      assert last_response.ok?
      assert_equal Project.all.to_json, last_response.body
    end

    test 'index returns paginated projects if pagination headers are present' do

    end

    test 'show returns a project by id' do
      get "/api/v1/projects/1"
      assert_equal Project.find(1).to_json, last_response.body
    end

    test 'show /:id returns 404 if project is not found' do

    end

    test 'create creates a project' do

    end

    test 'create returns 422 if params are invalid' do
    end

    test 'update /:id updates a project' do
    end

    test 'update returns 404 if project is not found' do
    end

    test 'destroy destroys a project' do
    end

    test 'destroy returns 404 if project is not found' do
    end
  end
end