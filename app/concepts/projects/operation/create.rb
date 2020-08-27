module Projects::Operation
  class Create < Trailblazer::Operation
    step Model(Project, :new)
    step Subprocess(Task::Modify)
  end
end
