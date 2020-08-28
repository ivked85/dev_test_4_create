require 'test_helper'

module API::V1
  class Projects::APITest < ActiveSupport::TestCase
    include Rack::Test::Methods

    def app
      Rails.application
    end

    test 'INDEX returns an array of serialized projects' do
      get '/api/v1/projects'
      assert last_response.ok?
      assert_equal Project.all.to_json, last_response.body
    end

    test 'INDEX returns paginated projects if pagination headers are present' do
      header 'Pagination-Page', '2'
      header 'Pagination-Limit', '1'

      get '/api/v1/projects'

      assert last_response.ok?
      assert_equal Project.where(id: 3).to_json, last_response.body
    end

    test 'SHOW returns a project by id' do
      get "/api/v1/projects/1"

      assert last_response.ok?
      assert_equal Project.find(1).to_json, last_response.body
    end

    test 'SHOW /:id returns 404 if project is not found' do
      get "/api/v1/projects/178"

      assert last_response.client_error?
      assert_equal 404, last_response.status
      assert_match /Couldn't find project/, last_response.body
    end

    test 'CREATE creates a project' do
      assert_difference 'Project.all.count' do
        post "/api/v1/projects", new_project_params.to_json, { 'CONTENT_TYPE' => 'application/json' }

        assert last_response.created?
        assert_equal 201, last_response.status
        assert Project.find_by(name: 'A new project')
      end
    end

    test 'CREATE returns 400 if params are invalid' do
      post "/api/v1/projects", { project: {}}.to_json, { 'CONTENT_TYPE' => 'application/json' }

      assert last_response.client_error?
      assert_equal 400, last_response.status
    end

    test 'CREATE returns 422 if creation fails' do
      post "/api/v1/projects", invalid_project_params.to_json, { 'CONTENT_TYPE' => 'application/json' }

      assert last_response.client_error?
      assert_equal 422, last_response.status
    end

    test 'UPDATE /:id updates a project' do
      put "/api/v1/projects/1", update_project_params.to_json, { 'CONTENT_TYPE' => 'application/json' }

      assert last_response.ok?
      assert_equal 'updated project', Project.find(1).name
    end

    test 'UPDATE returns 404 if project is not found' do
      put "/api/v1/projects/178", update_project_params.to_json, { 'CONTENT_TYPE' => 'application/json' }

      assert last_response.client_error?
      assert_equal 404, last_response.status
    end

    test 'UPDATE returns 422 if project cannot be updated' do
      put "/api/v1/projects/1", invalid_project_params.to_json, { 'CONTENT_TYPE' => 'application/json' }

      assert last_response.client_error?
      assert_equal 422, last_response.status
    end

    test 'DESTROY destroys a project' do
      assert Project.find(1)

      delete '/api/v1/projects/1'

      assert last_response.no_content?
      assert_not Project.find_by(id: 1)
    end

    test 'DESTROY returns 404 if project is not found' do
      delete 'api/v1/projects/178'

      assert last_response.client_error?
      assert_equal 404, last_response.status
    end

  private

    def new_project_params
      {
        project: {
          name: "A new project",
          status: "pending"
        }
      }
    end

    def invalid_project_params
      {
        project: {
          name: 'A new project',
          status: 'invalid'
        }
      }
    end

    def update_project_params
      {
        project: {
          name: 'updated project'
        }
      }
    end
  end
end