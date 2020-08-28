class MockPolicyService
  attr_reader :user, :resource, :action

  def initialize(user, resource, action)
    @user = user
    @resource = resource
    @action = action
  end

  def authorized?
    collection? ? authorize_project_collection : authorize_single_project
  end

private

  def authorize_single_project
    call_microservice(:authorize_project, resource) &&
      call_microservice(:authorize_client, resource.client)
  end

  def authorize_project_collection
    call_microservice(:authorize_projects, resource) && 
      authorize_client_collection
  end

  def authorize_client_collection
    clients = resource.map(&:client).reject(&:nil?).uniq
    call_microservice(:authorize_clients, clients)
  end

  def collection?
    action == :index
  end

  def call_microservice(service, resource)
    # pass service, user, resource and action to microservice
    true
  end
end
