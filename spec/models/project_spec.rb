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

  context "#updates_and_notifies" do
    let(:project) { FactoryGirl.create(:project) }
    let(:user) { project.user }
    let(:different_user) { FactoryGirl.create(:user) }
    let(:another_user) { FactoryGirl.create(:user) }
    let(:message) { "#{project.class} - #{project.title} has been recently updated :* description was changed to wind of change" }

    before do
      UserProject.create(user: different_user, project: project)
      UserProject.create(user: another_user, project: project)
      params = project.attributes
      params["description"] = "wind of change"
      project.update_and_notify params, user, :contributors
    end

    it "updates project record" do
      expect(project.description).to eql("wind of change")
    end

    it "sends notification to users that are contributors but not manager" do
      expect(another_user.incoming_notifications.to_a)
        .to match_array(Notification.where(user: another_user, notificable: project))

      expect(different_user.incoming_notifications.to_a)
        .to match_array(Notification.where(user: different_user, notificable: project))
    end

    it "sends no notification to the manager" do
      expect(user.incoming_notifications.to_a)
        .to be_empty
    end

    it "notifies users with a proper message" do
      expect(different_user.incoming_notifications.first.message)
        .to eq(message)

      expect(another_user.incoming_notifications.first.message)
        .to eq(message)
    end
  end

  context "#create_project" do
    let(:user) { FactoryGirl.build(:user) }
    let(:project) { FactoryGirl.build(:project) }
    before { project.create_project(user) }

    it "saves project to db" do
      expect(project).to eq(Project.last)
    end

    it "assigns user to project contributors" do
      expect(UserProject.last.user).to eq(user)
    end
  end

  context "#destroy and notify" do
    let(:project) { FactoryGirl.create(:project) }
    let(:author) { project.user}
    let(:user) { FactoryGirl.create(:user) }
    let(:message) { "#{project.class}  - #{project.title} has been removed." }

    before do
      UserProject.create(user: user, project: project)
      project.destroy_and_notify(author, :contributors)
    end

    it "deletes project form db" do
      expect(Project.all).to eq([])
    end

    it "sends no notifications to the executor of delete action" do
      expect(author.incoming_notifications).to be_empty
    end

    it "sends proper notification to project contributors" do
      expect(user.incoming_notifications.to_a)
        .to match_array(Notification.where(user: user, message: message) )
    end

    it "notifies with a proper message" do
      expect(user.incoming_notifications.first.message)
        .to eq(message)
    end
  end
end
