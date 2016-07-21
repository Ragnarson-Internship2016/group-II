require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) { FactoryGirl.create(:user) }
  subject(:task1) { FactoryGirl.create(:task) }
  subject(:task2) { FactoryGirl.create(:task) }

  context "with a proper validations setup user" do
    it "is valid with all params provided" do
      expect(user).to be_valid
    end
  end

  context "with improper validations setup user" do
    it "is not valid without a name" do
      user.name = nil
      expect(user).not_to be_valid
    end

    it "is not valid without a surname" do
      user.surname = nil
      expect(user).not_to be_valid
    end
  end

  context "with properly setup association - user has many managed projects" do
    it "returns an empty array of projects when no project has been created by the user" do
      expect(user.managed_projects).to be_empty
    end

    it "returns an array of projects created by the user" do
      projects = []
      2.times { projects << user.managed_projects.create(title: "shop application", description: "exercise", date: "1/12/2016") }
      expect(user.managed_projects.to_a).to eql(projects)
    end
  end

  context "with properly setup association - user has many contributed projects" do
    it "returns an empty array of projects when user does no contribute to any project" do
      expect(user.contributed_projects).to be_empty
    end

    it "returns array of projects that user contribute to" do
      projects = []
      5.times do
        projects << user.managed_projects.create(title: "shop application", description: "exercise", date: "1/12/2016")
        UserProject.create(user: user, project: projects.last)
      end
      expect(user.contributed_projects.to_a).to eql(projects)
    end
  end

  context "with properly setup association many to many user-task" do
    it "returns empty list of assigned tasks if not assigend" do
      expect(user.assigned_tasks).to be_empty
    end

    it "returns list of assigned tasks if specified" do
      UserTask.create(user: user, task: task1)
      UserTask.create(user: user, task: task2)
      expect(user.assigned_tasks.to_a).to eql([task1, task2])
    end
  end
end
