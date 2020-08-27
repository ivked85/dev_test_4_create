module Projects::Operation
  class Show < Trailblazer::Operation
    step Subprocess(Task::Find)
  end
end
