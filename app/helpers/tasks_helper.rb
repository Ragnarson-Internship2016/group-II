module TasksHelper
  def task_form_id(task)
    "#{task.project.id}-#{task.id}"
  end
end
