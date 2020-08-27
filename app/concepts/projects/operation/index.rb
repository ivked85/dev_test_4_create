module Projects::Operation
  class Index < Trailblazer::Operation
    step :model!

  private

    def model!(ctx, *)
      ctx['model'] = Project.all
    end
  end
end
