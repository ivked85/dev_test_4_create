module Projects::Operation
  class Update < BaseOperation
    step Subprocess(Task::Find)
    step Subprocess(Task::Authorize)
    step Subprocess(Task::Modify)
  end
end
