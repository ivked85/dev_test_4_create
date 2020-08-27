module Projects::Operation
  class Find < Trailblazer::Operation
    step Model(Project, :find_by)
    fail :handle_not_found!

  private

    def handle_not_found!(ctx, params:, **)
      ctx['errors'] = "Couldn't find project with id: #{params['id']}"
      ctx['code'] = 404
    end
  end
end
