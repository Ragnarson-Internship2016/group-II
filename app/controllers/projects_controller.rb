class ProjectsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = Project.all
  end

  def managed
    @projects = current_user.managed_projects.all
  end

  def contributed
    @projects = current_user.contributed_projects.all
  end

  def show
  end

  def new
    @project = current_user.managed_projects.new
  end

  def create
    @project = current_user.managed_projects.new(project_params)
    if @project.save && UserProject.create(user: current_user, project: @project)
      redirect_to @project, notice: "Poject was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Poject was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_url, notice: "Poject was successfully destroyed."
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, :date)
  end

  def record_not_found
    render file: 'public/404.html', status: :not_found
  end
end
