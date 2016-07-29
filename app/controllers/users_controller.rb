class UsersController < ApplicationController
  def dashboard
    @user_tasks = current_user.assigned_tasks.projects_with_not_done_tasks
    @contributed = []
    current_user.contributed_projects.each do |project|
      @contributed << project if project.user != current_user
    end
    @managed = current_user.managed_projects
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
