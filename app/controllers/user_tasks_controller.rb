class UserTasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task
  before_action { authorize @task }

  def assign
    begin
      @user_task = UserTask.create!(user: current_user, task: @task)
      redirect_to [@task.project, @task], notice: "Task successfully assigned."
    rescue
      redirect_to [@task.project, @task], notice: "Assignment faild - unable to save record in database."
    end
  end

  def leave
    if @user_task = UserTask.find_by(user: current_user, task: @task)
      @user_task.destroy
      redirect_to [@task.project, @task], notice: "Task assigment was removed."
    else
      redirect_to [@task.project, @task], notice: "Unable to remove - such assignment does not exist."
    end
  end

  private
  def set_task
    begin
      @task = Task.find(params[:id])
    rescue
      redirect_to project_tasks_path, notice: "Unable to find requested task."
    end
  end
end
