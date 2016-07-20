require 'rails_helper'

RSpec.describe UserProject, type: :model do
  let(:user) { User.create(name: "Wojtek", surname: "Pospiech", email: "a@a.pl", password: "topsecret") }
  let(:project) { user.managed_projects.create(title: "shop application", description: "exercise", date: "1/12/2016") }
  let(:employee) { User.create(name: "Romek", surname: "Banan", email: "emp@a.pl", password: "topsecret") }

  context "With proper parameters" do
    it "Adds new contributor to project" do
      user_project = UserProject.create(user: employee, project: project)
      expect(user_project).to be_valid
    end

    it "doesnt add duplicated record" do
      expect {
        2.times { UserProject.create(user: employee, project: project) }
      }.to raise_error
    end
  end

  context "With improper parameters" do
    it "doesnt add contributor to project if user is not provided" do
      user_project = UserProject.create(project: project)
      expect(user_project).not_to be_valid
    end

    it "doesnt add contributor to project if specific project is not given" do
      user_project = UserProject.create(user: employee)
      expect(user_project).not_to be_valid
    end
  end
end
