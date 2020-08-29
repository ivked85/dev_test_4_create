module Projects::Operation
  class Create < BaseOperation
    step Model(Project, :new)
    step Subprocess(Task::Authorize)
    step Subprocess(Task::Modify)
  end
end
