require 'test_helper'

class UpdateTest < ActiveSupport::TestCase
  test 'should update a project' do
    result = Projects::Operation::Update.(params: project_name_update_params)

    assert result.success?
    assert_equal 'A renamed project', Project.find_by(id: 1).name
  end

  test 'should add a new client to project' do
    old_client_count = Client.all.count
    assert_not Client.find_by(name: 'Clark Kent')

    result = Projects::Operation::Update.(params: update_project_with_new_client_params)

    assert result.success?
    assert_equal old_client_count + 1, Client.all.count
    assert Client.find_by(name: 'Clark Kent')
    assert_equal Client.find_by(name: 'Clark Kent'), Project.find(1).client
  end

  test 'should add an existing client to project' do
    old_client = Project.find(1).client
    new_client = Client.find_by(name: 'Jane Doe')
    old_client_count = Client.all.count

    result = Projects::Operation::Update.(params: update_project_with_existing_client_params)

    assert result.success?
    assert_equal old_client_count, Client.all.count
    assert_equal new_client, Project.find(1).client
    assert_not_equal old_client, new_client
  end

  test 'should return error and 404 if project cannot be found' do
    result = Projects::Operation::Update.(params: invalid_project_update_params)

    assert_not result.success?
    assert_equal "Couldn't find project with id: 178", result['errors']
    assert_equal 404, result['code']
  end

  test 'should return error and 403 if user is unauthorized' do
    result = Projects::Operation::Update.(params: project_name_update_params,
                                          current_user: 'unauthorized')

    assert_not result.success?
    assert_match(/You are not authorized/, result['errors'])
    assert_equal 403, result['code']
  end

  private

  def project_name_update_params
    {
      id: 1,
      project: {
        name: 'A renamed project'
      }
    }
  end

  def invalid_project_update_params
    {
      id: 178,
      project: {
        name: 'A renamed project'
      }
    }
  end

  def update_project_with_new_client_params
    {
      id: 1,
      project: {
        client: new_client_params
      }
    }
  end

  def update_project_with_existing_client_params
    {
      id: 1,
      project: {
        client: existing_client_params
      }
    }
  end

  def new_client_params
    {
      name: 'Clark Kent'
    }
  end

  def existing_client_params
    {
      name: 'Jane Doe'
    }
  end
end
