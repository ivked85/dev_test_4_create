module API::V1
  class Projects < Grape::API
    # TODO: include API::V1::Defaults
    prefix 'api'
    version 'v1'
    format :json

    resource :projects do
      desc 'Returns all projects'
      get do
        { projects: Project.all }
      end

      desc 'Returns a project'
      params do
        requires :id, type: String, desc: 'ID of the project'
      end
      get ':id' do
        { project: Project.find(params['id']) }
      end

      desc 'Creates a project'
      params do
        requires :project, type: Hash, desc: 'Project object' do
          requires :name, type: String, desc: 'Project name'
          requires :status, type: String, desc: 'one of: pending, in_progress, finished'
          optional :client, type: Hash, desc: 'Client object' do
            requires :name, type: String, desc: 'Client name'
          end
        end
      end
      post do
        result = Project::Create.(params: params)
        if result.success?
          {}
        else
          error!(result['errors'], 422)
        end
      end
    end
  end
end
