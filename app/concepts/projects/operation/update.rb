module Projects::Operation
  class Update < BaseOperation
    step Subprocess(Task::Find)
    step Subprocess(Task::Modify)
    step Subprocess(Task::Authorize)
  end
end
