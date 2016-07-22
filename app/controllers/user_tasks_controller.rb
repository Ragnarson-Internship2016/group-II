class UserTasksController < ApplicationController
  before_action :set_task

  def assign
    if UserTask.create(user: current_user, task: task)
      redirect_to [task.project, task], notice: "Successfully assigned!"
    else
      redirect_to [task.project, task], notice: "Error, cannot assigned!"
    end
  end

  def leave
    user_task = UserTask.where(user: current_user, task: task)
    user_task.destroy

    redirect_to [task.project, task], notice: "You are no logner assigned to this task!"
  end

  private
  def set_task
    @task = Task.find(params[:id])
  end
end
