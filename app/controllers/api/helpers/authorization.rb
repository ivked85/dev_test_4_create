module API::Helpers::Authorization
  extend Grape::API::Helpers

  def authorize_user!
    return true unless protected_request
    return true  if ::MockAuthorizationService.authorize_request(current_user, protected_request)
    error!('Not allowed', 401)
  end

  def current_user
    return 'unauthenticated' if headers['Unauthenticated']
    return 'unauthorized' if headers['Unauthorized']
    'allowed'
  end

  def protected_request
    route_setting(:description)[:named]
  end
end
