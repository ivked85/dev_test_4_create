module Projects::Operation::Task
  class Authorize < Trailblazer::Operation
    step Policy::Guard(:authorized?)
    fail :handle_unauthorized!

  private

    def authorized?(ctx, current_user: nil, **)
      ::MockPolicyService.new(current_user, ctx['model'], ctx['action']).authorized?
    end

    def handle_unauthorized!(ctx, current_user: nil, **)
      ctx['errors'] = "You are not authorized to access this resource"
      ctx['code'] = 403
    end
  end
end
