class TasksController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_task, except: [:new, :create, :index]
  before_action :check_if_params_match, except: [:new, :create, :index]

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
    if @task.save
      redirect_to [@project, @task], notice: "Task was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to [@project, @task], notice: "Task was successfully updated."
    else
      render :edit
    end
  end

  def mark_as_done
    respond_to do |format|
      if @task.update(done: true)
        format.html { redirect_to project_tasks_path, notice: "Task marked as DONE." }
        format.json { head :ok }
      else
        format.html { redirect_to project_tasks_path, notice: "Error, unable to mark as done" }
        format.json { head :bad_request }
      end
    end
  end

  def destroy
    @task.destroy
    redirect_to project_tasks_path, notice: "Task was successfully destroyed."
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def check_if_params_match
    unless @project.tasks.include?(@task)
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Error, requested task is not associated with this project" }
        format.json { head :not_found }
      end
    end
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date)
  end
end
