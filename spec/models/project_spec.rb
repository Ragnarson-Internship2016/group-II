require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:user) { User.build(name: "Wojtek", surname: "Pospiech", email: "a@a.pl", password: "topsecret") }

  context "with invalid params" do
    it "is not valid without title" do
      project = FactoryGirl.build(:project, title: nil)
      expect(project).not_to be_valid
    end

    it "is not valid without description" do
      project = FactoryGirl.build(:project, description: nil)
      expect(project).not_to be_valid
    end

    it "is not valid without a date" do
      project = FactoryGirl.build(:project, date: nil)
      expect(project).not_to be_valid
    end
  end

  context "when validations are skipped" do
    it "raises a db error when attempting to save null in title column" do
      expect {
        project = FactoryGirl.build(:project, title: nil)
        project.save!(validate: false)
      }.to raise_error
    end

    it "raises a db error when attempting to save null in description column" do
      expect {
        project = FactoryGirl.build(:project, description: nil)
        project.save!(validate: false)
      }.to raise_error
    end

    it "raises a db error when attempting to save date in date column" do
      expect {
        project = FactoryGirl.build(:project, date: nil)
        project.save!(validate: false)
      }.to raise_error
    end

    it "does not saves project when one is not buildd by existing user" do
      project = FactoryGirl.build(:project, user: nil)
      expect(project).not_to be_valid
    end
  end

  context "with valid params" do
    it "saves projects when all params are given" do
      project = FactoryGirl.build(:project)
      expect(project).to be_valid
    end
  end

  context "with poperly setup association - project belongs to user" do
    it "returns a user instance" do
      user = FactoryGirl.build(:user)
      project = FactoryGirl.build(:project, user: user)

      expect(project.user).to eql(user)
    end
  end

  context "with properly setup association - project has many contributors" do
    it "returns an array of users that are contributors of a given project" do
      contributors = []

      2.times { contributors << FactoryGirl.build(:user) }

      project = FactoryGirl.build(:project_with_contributors, contributors: contributors)

      expect(project.contributors.to_a).to eql(contributors)
    end
  end
end
