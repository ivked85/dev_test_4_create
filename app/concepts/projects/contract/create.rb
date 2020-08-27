module Projects::Contract
  class Create < Reform::Form
    property :name
    property :status

    property :client, populator: :client! do
      property :name
      
      validation do
        params do
          required(:name).filled
        end
      end
    end
    
    validation do
      params do
        required(:name).filled
        required(:status).filled(Types::Statuses)
      end
    end

private

    def client!(fragment:, **)
      self.client = Client.find_by(fragment) || Client.new
    end

    module Types
      include Dry.Types(default: :nominal)

      Statuses = Types::Strict::String.enum({ 'pending' => 0, 'in_progress' => 1, 'finished' => 2})
    end
  end
end
