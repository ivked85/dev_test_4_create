require 'test_helper'

class CreateTest < ActiveSupport::TestCase
  test 'should create a valid project with no client' do
    result = Projects::Operation::Create.(params: project_without_client)

    assert result.success?
    assert result['model'].persisted?
    assert_equal 'A cool project', result['model'].name
  end

  test 'should create a project with a new client' do
    assert_not Client.find_by(name: 'Clark Kent')

    result = Projects::Operation::Create.(params: project_with_new_client)

    assert result.success?
    assert result['model'].persisted?
    assert_equal 'A cool project', result['model'].name
    assert Client.find_by(name: 'Clark Kent')
  end

  test 'should create a project with an existing client' do
    client = Client.find_by(name: 'John Doe')
    old_client_count = Client.all.count

    result = Projects::Operation::Create.(params: project_with_existing_client)

    assert result.success?
    assert result['model'].persisted?
    assert_equal 'A cool project', result['model'].name

    assert_equal client, result['model'].client
    assert_equal old_client_count, Client.all.count
  end

  test 'should return error and code if project params are invalid' do
    result = Projects::Operation::Create.(params: invalid_project)

    assert_not result.success?
    assert_equal({:status=>["must be one of: pending, in_progress, finished"]}, result['errors'])
    assert_equal 422, result['code']
  end

  test 'should return error and 403 if user is unauthorized' do
    result = Projects::Operation::Create.(params: project_without_client,
                                          current_user: 'unauthorized')

    assert_not result.success?
    assert_match /You are not authorized/, result['errors']
    assert_equal 403, result['code']
  end

private

  def project_with_existing_client
    {
      project: valid_project_params.merge(client: existing_client_params)
    }
  end

  def project_with_new_client
    {
      project: valid_project_params.merge(client: new_client_params)
    }
  end

  def project_without_client
    {
      project: valid_project_params
    }
  end

  def invalid_project
    {
      project: invalid_project_params
    }
  end

  def valid_project_params
    {
      name: 'A cool project',
      status: 'pending'
    }
  end

  def invalid_project_params
    {
      name: 'Bad project',
      status: 'invalid status'
    }
  end

  def new_client_params
    {
      name: 'Clark Kent'
    }
  end

  def existing_client_params
    {
      name: 'John Doe'
    }
  end
end
