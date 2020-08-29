module Projects::Operation::Task
  class Modify < Trailblazer::Operation
    step Contract::Build(constant: Projects::Contract::Create)
    step Contract::Validate(key: :project)
    fail :handle_validation_error!
    step Contract::Persist()

    private

    def handle_validation_error!(ctx, *)
      ctx['errors'] = ctx['contract.default'].errors.messages
      ctx['code'] = 422
    end
  end
end
