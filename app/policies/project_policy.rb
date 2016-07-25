class ProjectPolicy
  def initialize(user, project)
    @user = user
    @project = project
  end

  def access?
    @user && @user.takes_part_in_project?(@project.id)
  end
end
