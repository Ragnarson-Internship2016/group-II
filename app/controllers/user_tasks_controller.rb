class UserTasksController < ApplicationController
  before_action :set_task

  def assign
    begin
      @user_task = UserTask.create!(user: current_user, task: @task)
      redirect_to [@task.project, @task], notice: "Successfully assigned!"
    rescue
      redirect_to [@task.project, @task], notice: "Error, cannot assigned!"
    end
  end

  def leave
    if @user_task = UserTask.find_by(user: current_user, task: @task)
      @user_task.destroy
      redirect_to [@task.project, @task], notice: "You are no logner assigned to this task!"
    else
      redirect_to [@task.project, @task], notice: "Error, cannot remove assignment!"
    end
  end

  private
  def set_task
    begin
      @task = Task.find(params[:id])
    rescue
      redirect_to project_tasks_path, notice: "Error, wrong parameters in the request!"
    end
  end
end
