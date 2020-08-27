module Projects::Operation
  class Update < Trailblazer::Operation
    step Subprocess(Find)
    step Subprocess(Modify)
  end
end
