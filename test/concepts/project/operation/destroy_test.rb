require 'test_helper'

class DestroyTest < ActiveSupport::TestCase
  test 'should destroy a project' do
    assert Project.find_by(id: 1)

    result = Projects::Operation::Destroy.(params: {id: 1})

    assert_not Project.find_by(id: 1)
  end

  test 'should return error and code when project is not found' do
    result = Projects::Operation::Destroy.(params: {id: 178})

    assert_equal "Couldn't find project with id: 178", result['errors']
    assert_equal 404, result['code']
  end
end
