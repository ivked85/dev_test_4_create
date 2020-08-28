require 'test_helper'

class ShowTest < ActiveSupport::TestCase
  test 'should return a project' do
    result = Projects::Operation::Show.(params: {id: 1})

    assert result.success?
    assert_equal 'Project X', result['model'].name
  end

  test 'should return error and code when project is not found' do
    result = Projects::Operation::Show.(params: {id: 178})

    assert_not result.success?
    assert_equal "Couldn't find project with id: 178", result['errors']
    assert_equal 404, result['code']
  end
end
