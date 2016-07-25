class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_poject, only: [:show, :edit, :update, :destroy]

  def managed_projects
    @projects = current_user.managed_projects.all
  end

  def contributed_projects
    @projects = current_user.contributed_projects.all
  end

  def show
  end

  def new
    @project = current_user.managed_projects.new
  end

  def create
    @project = current_user.managed_projects.new(poject_params)
    if @project.save
      redirect_to @poject, notice: "Poject was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @poject.update(poject_params)
      redirect_to @poject, notice: "Poject was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @poject.destroy
    redirect_to pojects_url, notice: "Poject was successfully destroyed."
  end

  private

  def set_project
    @poject = Project.find(params[:id])
  end

  def project_params
    params.require(:poject).permit(:title, :description, :date)
  end
end
