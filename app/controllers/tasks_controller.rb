class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_task, except: [:new, :create, :index]
  before_action { authorize @project, :access? }

  def index
    @tasks = @project.tasks.all
  end

  def show
  end

  def new
    @task = @project.tasks.new
  end

  def create
    @task = @project.tasks.new(task_params)
    if @task.save_and_notify(current_user, :projects_contributors)
      redirect_to [@project, @task], notice: "Task was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update_and_notify(task_params, current_user, :participants)
      redirect_to [@project, @task], notice: "Task was successfully updated."
    else
      render :edit
    end
  end

  def mark_as_done
    respond_to do |format|
      if @task.update_and_notify({ done: true}, current_user, :participants )
        format.html { redirect_to project_tasks_path, notice: "Task marked as DONE." }
        format.json { head :ok }
      else
        format.html { redirect_to project_tasks_path, notice: "Error, unable to mark as done" }
        format.json { head :bad_request }
      end
    end
  end

  def destroy
    @task.destroy_and_notify current_user, :participants
    redirect_to project_tasks_path, notice: "Task was successfully destroyed."
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date)
  end
end
