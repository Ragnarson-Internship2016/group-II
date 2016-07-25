require 'rails_helper'

RSpec.describe Project, type: :model do
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

  context "when associated events exist" do
    context "when created with single project factory" do
      subject { FactoryGirl.create(:project_with_events) }

      it "contains associated events count" do
        expect(subject.events.size).to eql(3)
      end

      it "deletes events on project destroy" do
        subject.user_projects.delete_all
        expect { subject.destroy }.to change { subject.events.count }.by(-3)
      end
    end

    context "when events added to existing project" do
      subject { FactoryGirl.create(:project) }

      it "contains associated events" do
        events = 3.times.collect do
          FactoryGirl.create(:event, project: subject)
        end
        expect(subject.events.to_a).to match_array(events)
      end
    end
  end

  context "with poperly setup association - project has_many tasks" do
    it "has 3 tasks" do
      project = FactoryGirl.create(:project_with_tasks)
      expect(project.tasks.length).to eql(3)
    end

    it "destroys tasks when the project is removed" do
      project = FactoryGirl.create(:project_with_tasks)
      expect { project.destroy }.to change { project.tasks.count }.by(-3)
    end
  end
end
