class UsersController < ApplicationController
  def dashboard
    @user_tasks = current_user.assigned_tasks.projects_with_not_done_tasks
    @user_projects = current_user.projects
  end

  def search
    @users = find_for_search(params[:name])
    @project = Project.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  private

  def find_for_search(param)
    find_name, find_surname = param.split(" ")
    if find_surname
      users = User.where("name like ? AND surname like ?",
        "#{find_name}%",
        "#{find_surname}%")
    else
      users = (
        User.where("name like ?", "#{find_name}%") +
        User.where("surname like ?", "#{find_name}%")).
        uniq
    end
    users
  end
end
