module API::V1
  class Projects < Grape::API
    include API::Defaults

    resource :projects do
      desc 'Returns all projects'
      get do
        index
      end

      desc 'Returns a project'
      params do
        requires :id, type: String, desc: 'ID of the project'
      end
      get ':id' do
        show
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
        create do |result|
          header['Location'] = "#{request.url}/#{result['model'].id}"
          env['api.format'] = :txt
          nil
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
        update { |result| result['model'] }
      end

      desc 'Deletes a project'
      params do
        requires :id, type: String, desc: 'ID of the project'
      end
      delete ':id' do
        destroy { body false }
      end
    end
  end
end
