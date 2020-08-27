module Projects::Operation
  class Update < Trailblazer::Operation
    step Subprocess(Task::Find)
    step Subprocess(Task::Modify)
  end
end
