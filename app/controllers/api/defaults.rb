module API::Defaults
  extend ActiveSupport::Concern

  included do
    helpers API::ResourceOperations, API::Authorization

    prefix 'api'
    version 'v1'
    format :json
  end
end
