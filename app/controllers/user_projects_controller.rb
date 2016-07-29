class UserProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_user, except: :participants
  before_action only: [:participants] { authorize @project, :access? }

  def create
    if current_user.managed_projects.include?(@project)
      begin
        user_project = UserProject.create!(user: @user, project: @project)
        redirect_to project_participants_path(@project), notice: "User successfully assigned."
      rescue
        redirect_to link_contributors_project_path(@project), notice: "User already assigned."
      end
    else
      redirect_to root_url, notice: "You cannot add anyone to project if you did not create it."
    end
  end

  def destroy
    if current_user.managed_projects.include?(@project)
      if user_project = UserProject.find_by(user: @user, project: @project)
        user_project.destroy
        redirect_to project_participants_path(@project), notice: "User assignment was removed."
      else
        redirect_to project_participants_path(@project), notice: "User was not assigned to this project."
      end
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
    @project = Project.find(params[:project_id])
  end

  def set_user
    @user = User.find(params["user_id"])
    if @user == @project.user
      redirect_to link_contributors_project_path(@project), notice: "Assignment forbidden - manager settings cannot be changed."
    end
  end
end
