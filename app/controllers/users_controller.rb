class UsersController < ApplicationController
  def dashboard
    @user_tasks = current_user.assigned_tasks.projects_with_not_done_tasks
    @user_projects = current_user.projects
  end
end
