module Projects::Operation
  class Create < BaseOperation
    step Model(Project, :new)
    step Subprocess(Task::Modify)
    step Subprocess(Task::Authorize)
  end
end
