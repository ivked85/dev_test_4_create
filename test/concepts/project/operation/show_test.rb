require 'test_helper'

class ShowTest < ActiveSupport::TestCase
  test 'should return a project' do
    result = Projects::Operation::Show.(params: {id: 1})

    assert_equal 'Project X', result['model'].name
  end
end
