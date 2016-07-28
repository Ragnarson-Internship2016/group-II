class UsersController < ApplicationController
  def dashboard
    @user_tasks = current_user.assigned_tasks.projects_with_not_done_tasks
    @user_projects = current_user.projects
  end

  def search
    @users = User.where(name: params[:name])
    @project = Project.find(params[:id])
    respond_to do |format|
      format.js
    end
  end
end
