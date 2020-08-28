module Projects::Operation
  class BaseOperation < Trailblazer::Operation
    step :action!

  private

    def action!(ctx, *)
      ctx['action'] = self.class.name.split('::').last.downcase.to_sym
    end
  end
end
