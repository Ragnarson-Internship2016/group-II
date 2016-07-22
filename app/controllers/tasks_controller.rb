class TasksController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_project, only: [:project_assigned, :update, :create, :new]
  before_action :set_task, only: [:show, :edit, :update, :destroy, :mark_as_done]

  #/my_tasks or juts on home page
  def user_assigned
    @tasks = current_user.tasks
  end

  #/projects/2/tasks
  def project_assigned
    @tasks = @project.tasks
  end

  #/projects/2/tasks/3
  def show
  end

  # GET /projects/2/tasks
  def new
    @task = current_user.tasks.new
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
    @task = current_user.tasks.new(task_params) #params should have project_id
    if @task.update
      redirect_to [@project, @task], notice: "Task was successfully updated."
    else
      render :edit
    end
  end

  def mark_as_done
    @task.done = true
    if @task.update
      respond_to { |format| format.js } #change dynamically div
    else
      respond_to { |format| format.js { render "unable_to_mark_as_done" } }
    end
  end

  def destroy
    @task.destroy
    redirect_to :back , notice: "Task was successfully destroyed."
  end

  private

  def set_project
    @project = Project.find(params[:project_id || :id])
  end

  def set_task
    @project = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description) # add project?
  end
end
