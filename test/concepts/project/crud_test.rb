class CrudTest < ActiveSupport::TestCase
  test 'should persist valid project' do
    project = Project::Create.(
      name: 'A first project',
      status: 'pending'
    ).model

    assert project.persisted?
    assert_equal 'A first project', project.name
    assert project.pending?
  end   
end
