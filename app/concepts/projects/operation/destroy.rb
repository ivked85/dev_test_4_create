module Projects::Operation
  class Destroy < BaseOperation
    step Subprocess(Task::Find)
    step :destroy!
    step Subprocess(Task::Authorize)

    private

    def destroy!(ctx, *)
      ctx['model'].destroy
    end
  end
end
