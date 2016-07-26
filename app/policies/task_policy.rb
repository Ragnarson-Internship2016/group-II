class TaskPolicy
  def initialize(user, task)
    @user = user
    @task = task
  end

  def assign?
    authorize_project_member
  end

  def leave?
    authorize_project_member
  end

  private

  def authorize_project_member
    @user && @user.takes_part_in_project?(@task.project_id)
  end
end
