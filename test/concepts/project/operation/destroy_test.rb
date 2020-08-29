require 'test_helper'

class DestroyTest < ActiveSupport::TestCase
  test 'should destroy a project' do
    assert Project.find_by(id: 1)

    result = Projects::Operation::Destroy.(params: { id: 1 })

    assert result.success?
    assert_not Project.find_by(id: 1)
  end

  test 'should return error and code when project is not found' do
    result = Projects::Operation::Destroy.(params: { id: 178 })

    assert_not result.success?
    assert_equal "Couldn't find project with id: 178", result['errors']
    assert_equal 404, result['code']
  end

  test 'should return error and 403 if user is unauthorized' do
    result = Projects::Operation::Destroy.(params: { id: 1 },
                                           current_user: 'unauthorized')

    assert_not result.success?
    assert_match(/You are not authorized/, result['errors'])
    assert_equal 403, result['code']
  end
end
