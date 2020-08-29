module API::V1
  class Projects < Grape::API
    include API::Defaults

    resource :projects do
      desc 'Returns all projects' do
        named 'index-projects'
        headers(
          'Pagination-Page' => {
            description: 'requested page',
            required: false
          },
          'Pagination-Limit' => {
            description: 'items per page',
            required: false
          }
        )
        produces ['application/json']
      end
      get do
        index(headers: headers)
      end

      desc 'Returns a project' do
        named 'show-project'
      end
      params do
        requires :id, type: String, desc: 'ID of the project'
      end
      get ':id' do
        show
      end

      desc 'Creates a project' do
        named 'create-project'
        consumes ['application/json']
      end
      params do
        requires :project, type: Hash, documentation: { desc: 'Project object', param_type: 'body' } do
          requires :name, type: String, desc: 'Project name'
          requires :status, type: String, desc: 'one of: pending, in_progress, finished'
          optional :client, type: Hash, desc: 'Client object' do
            optional :name, type: String, desc: 'Client name'
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

      desc 'Updates a project' do
        named 'update-project'
      end
      params do
        requires :project, type: Hash, documentation: { desc: 'Project object', param_type: 'body' } do
          optional :name, type: String, desc: 'Project name'
          optional :status, type: String, desc: 'one of: pending, in_progress, finished'
          optional :client, type: Hash, desc: 'Client object' do
            requires :name, type: String, desc: 'Client name'
          end
        end
      end
      put ':id' do
        update do
          env['api.format'] = :txt
          nil
        end
      end

      desc 'Deletes a project' do
        named 'destroy-project'
      end
      params do
        requires :id, type: String, desc: 'ID of the project'
      end
      delete ':id' do
        destroy { body false }
      end

      def self.pagination_headers
        {
          'Pagination-Page' => {
            description: 'requested page',
            required: false
          },
          'Pagination-Limit' => {
            description: 'items per page',
            required: false
          }
        }
      end
    end
  end
end
