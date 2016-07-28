require 'rails_helper'

RSpec.describe Task, type: :model do
  subject(:task) { FactoryGirl.create(:task, project: project) }
  let(:project) { FactoryGirl.create(:project) }
  let(:employee_mark) { FactoryGirl.create(:user) }
  let(:employee_tom) { FactoryGirl.create(:user) }

  context "with valid task params" do
    it "it is valid with all task params" do
      expect(task).to be_valid
    end

    it "contains reference to correct project" do
      expect(task.project.id).to eql(task.project_id)
    end
  end

  context "with invalid task params" do
    it "is not valid without a title" do
      task.title = nil
      expect(task).not_to be_valid
    end

    it "is not valid without a description" do
      task.description = nil
      expect(task).not_to be_valid
    end

    it "is not valid without a due_date" do
      task.due_date = nil
      expect(task).not_to be_valid
    end

    it "raises error with try to save task without project" do
      task = FactoryGirl.build(:task)
      task.project = nil
      expect { task.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "is not valid with a past_date" do
      task.due_date = Date.today - 1.day
      task.validate
      expect(task.errors.messages[:due_date].first).
          to include("must be in future")
    end
  end

  context "with properly setup many to many association user-task" do
    it "returns empty list of participants if nobody is assigned" do
      expect(task.participants).to be_empty
    end

    it "returns array of prticipants" do
      UserTask.create(user: employee_mark, task: task)
      UserTask.create(user: employee_tom, task: task)
      expect(task.participants.to_a).to eql([employee_mark, employee_tom])
    end
  end

  context "#updates_and_notifies" do
    let(:task) { FactoryGirl.create(:task) }
    let(:another_user) { FactoryGirl.create(:user) }
    let(:user) { task.project.user }
    let(:message) { "#{task.class} - #{task.title} has been recently updated :* description was changed to wind of change" }

    before do
      UserProject.create(user: another_user, project: project)
      UserTask.create(user: user, task: task)
      UserTask.create(user: another_user, task: task)
      params = task.attributes
      params["description"] = "wind of change"
      task.update_and_notify(params, user, :participants)
    end

    it "updates task record" do
      expect(task.description).to eql("wind of change")
    end

    it "sends notification to users that are tasks participants" do
      expect(another_user.incoming_notifications.to_a)
        .to match_array(Notification.where(user: another_user, notificable: task))
    end

    it "sends no notification to the user that made changes" do
      expect(user.incoming_notifications.to_a)
        .to be_empty
    end

    it "notifies users with a proper message" do
      expect(another_user.incoming_notifications.first.message)
        .to eq(message)
    end
  end

  context "#saves_and_notifies" do
    let(:task) { FactoryGirl.build(:task) }
    let(:project) { task.project }
    let(:user) { project.user }
    let(:another_user) { FactoryGirl.create(:user) }
    let(:message) { "There is a new #{task.class} - #{task.title}, check this out!" }

    before do
      UserProject.create(user: another_user, project: project)
      UserTask.create(user: another_user, task: task)
      task.save_and_notify(user, :participants)
    end

    it "sends notification to users that are contributing to the project" do
      expect(another_user.incoming_notifications.to_a)
        .to match_array(Notification.where(user: another_user, notificable: task))
    end

    it "sends no notifications to the author" do
      expect(user.incoming_notifications)
        .to be_empty
    end

    it "notifies users with a proper message" do
      expect(another_user.incoming_notifications.first.message)
        .to eq(message)
    end
  end

  context "#destroy and notify" do
    let(:task) { FactoryGirl.create(:task) }
    let(:user) { FactoryGirl.create(:user) }
    let(:message) { "#{task.class}  - #{task.title} has been removed." }
    let(:another_user) { FactoryGirl.create(:user) }

    before do
      UserProject.create(user: another_user, project: task.project)
      UserProject.create(user: user, project: task.project)
      UserTask.create(user: another_user, task: task)
      task.destroy_and_notify(user, :participants)
    end

    it "deletes task form db" do
      expect(Task.all).to be_empty
    end

    it "sends no notifications to the executor of delete action" do
      expect(user.incoming_notifications).to be_empty
    end

    it "sends proper notification to project contributors" do
      expect(another_user.incoming_notifications.first.message)
        .to eq(message)
    end
  end
end
