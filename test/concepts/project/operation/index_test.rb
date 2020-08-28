require 'test_helper'

class IndexTest < ActiveSupport::TestCase
  test 'should return projects' do
    result = Projects::Operation::Index.(params: {})

    assert_equal 3, result['model'].count
  end

  test 'should return paginated projects if pagination headers are present' do
    result = Projects::Operation::Index.(
      params: {},
      headers: {
        'Pagination-Page' => '0',
        'Pagination-Limit' => '1'
      })
    assert_equal 1, result['model'].count
  end

  test 'should use default values when pagination params are negative' do
    result = Projects::Operation::Index.(
      params: {},
      headers: {
        'Pagination-Page' => '-5',
        'Pagination-Limit' => '-7'
      })

      assert_equal 3, result['model'].count
  end

  test 'should use default values when pagination params are invalid' do
    result = Projects::Operation::Index.(
      params: {},
      headers: {
        'Pagination-Page' => 'invalid',
        'Pagination-Limit' => 'invalid'
      })

      assert_equal 3, result['model'].count
  end
end
