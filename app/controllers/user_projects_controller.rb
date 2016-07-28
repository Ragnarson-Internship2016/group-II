class UserProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_user, except: :participants

  def create
    if current_user.managed_projects.include?(@project)
      user_project = UserProject.create!(user: @user, project: @project)
      redirect_to @project, notice: "User successfully assigned."
    else
      redirect_to root_url, notice: "You cannot add anyone to project if you did not create it."
    end
  end

  def destroy
    if current_user.managed_projects.include?(@project)
      user_project = UserProject.find_by(user: @user, project: @project)
      user_project.destroy
      redirect_to @project, notice: "User assignment was removed."
    else
      redirect_to root_url, notice: "You cannot remove anyone from project if you did not create it."
    end
  end

  def participants
    @manager = @project.user
    @contributors = @project.contributors - [@manager]
  end

  private
  def set_project
    p "aaaaaa", params
    @project = Project.find(params[:project_id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
