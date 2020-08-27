class Project::Create < Trailblazer::Operation
  step Model(Project, :new)
  step Contract::Build(constant: Project::Contract::Create)
  step Contract::Validate(key: :project)
  fail :handle_validation_error!
  step Contract::Persist()

private

  def handle_validation_error!(ctx, options)
    ctx['errors'] = ctx['contract.default'].errors.messages
  end

  def check(ctx, options)
    byebug
  end
end
