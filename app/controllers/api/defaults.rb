module API::Defaults
  extend ActiveSupport::Concern

  included do
    helpers API::Helpers::ResourceOperations, API::Helpers::Authorization

    before do
      authorize_user!
    end

    prefix 'api'
    version 'v1'
    format :json
  end
end
