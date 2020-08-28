module Projects::Operation
  class Show < BaseOperation
    step Subprocess(Task::Find)
    step Subprocess(Task::Authorize)
  end
end
