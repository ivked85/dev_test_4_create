module API::V1
  class Projects < Grape::API
    # TODO: include API::V1::Defaults
    prefix 'api'
    version 'v1'
    format :json

    resource :projects do
      desc 'Returns all projects'
      get do
        ::Projects::Operation::Index.(params: params)['model']
      end

      desc 'Returns a project'
      params do
        requires :id, type: String, desc: 'ID of the project'
      end
      get ':id' do
        result = ::Projects::Operation::Find.(params: params)
        if result.success?
          result['model']
        else
          error!(result['errors'], result['code'])
        end
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
        result = ::Projects::Operation::Create.(params: params)
        if result.success?
          result['model']
        else
          error!(result['errors'], result['code'])
        end
      end

      desc 'Updates a project'
      params do
        requires :project, type: Hash, desc: 'Project object' do
          optional :name, type: String, desc: 'Project name'
          optional :status, type: String, desc: 'one of: pending, in_progress, finished'
          optional :client, type: Hash, desc: 'Client object' do
            requires :name, type: String, desc: 'Client name'
          end
        end
      end
      put ':id' do
        result = ::Projects::Operation::Update.(params: params)
        if result.success?
          result['model']
        else
          error!(result['errors'], result['code'])
        end
      end

      desc 'Deletes a project'
      params do
        requires :id, type: String, desc: 'ID of the project'
      end
      delete ':id' do
        result = ::Projects::Operation::Destroy.(params: params)
        if result.success?
          body false
        else
          error!(result['errors'], result['code'])
        end
      end
    end
  end
end
