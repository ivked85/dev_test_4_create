module Projects::Operation
  class Destroy < Trailblazer::Operation
    step Subprocess(Find)
    step :destroy!

  private

    def destroy!(ctx, *)
      ctx['model'].destroy
    end
  end
end
