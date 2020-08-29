module Projects::Operation
  class Destroy < BaseOperation
    step Subprocess(Task::Find)
    step Subprocess(Task::Authorize)
    step :destroy!

    private

    def destroy!(ctx, *)
      ctx['model'].destroy
    end
  end
end
