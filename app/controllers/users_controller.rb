class UsersController < ApplicationController
  def dashboard
    @user_tasks = current_user.assigned_tasks.where(done: false).group_by(&:project)
    @user_projects = current_user.projects
  end
end
