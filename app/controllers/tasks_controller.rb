class TasksController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_task, except: [:new, :create]
  before_action :check_if_params_match, except: [:new, :create]

  #/projects/2/tasks/3
  def show
  end

  # GET /projects/2/tasks
  def new
    @task = @project.tasks.new
  end

  # POST /projects/2/tasks
  def create
    if @task.save!
      redirect_to [@project, @task], notice: "Task was successfully created."
    else
      render :new
    end
  end

  # GET /projects/2/tasks/5/edit
  def edit
  end

  # PUT /projects/2/tasks/5/
  def update
    @task = current_user.tasks.new(task_params)
    if @task.update
      redirect_to [@project, @task], notice: "Task was successfully updated."
    else
      render :edit
    end
  end

  def mark_as_done
    @task.done = true
    if @task.update
      redirect_to [@project, @task], notice: "Task was successfully updated."
    else
      redirect_to project_tasks_path, notice: "Error, unable to mark as done"
    end
  end

  def destroy
    @task.destroy
    redirect_to :back, notice: "Task was successfully destroyed."
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def check_if_params_match
    redirect_to root_path, notice: "Params don't match" unless @project.tasks.include?(@task)
  end

  def task_params
    params.require(:task).permit(:title, :description)
  end

  def record_not_found
    redirect_to root_path, notice: "Error, wrong params in the request - record could not be found"
  end
end
