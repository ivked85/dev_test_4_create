module API::Defaults
  extend ActiveSupport::Concern

  included do
    helpers API::ResourceOperations

    prefix 'api'
    version 'v1'
    format :json
  end
end
