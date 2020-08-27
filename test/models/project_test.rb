require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test 'should paginate' do
    all_projects = Project.paginate(page:0, limit: 100)
    
    assert_equal 2, Project.paginate(page: 0, limit: 2).count
    assert_equal all_projects.second, Project.paginate(page: 1, limit: 1).first
  end

  test 'to json uses fast JSON API' do
    assert_equal({
      "data"=>{
        "id"=>"168093765",
        "type"=>"project",
        "attributes"=>{"name"=>"Project Z", "status"=>2},
        "relationships"=>{
          "client"=>{
            "data"=>{"id"=>"980204181", "type"=>"client"}}}}},
      JSON.parse(Project.first.to_json))
  end
end
