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
      expect { task.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "is not valid with a past_date" do
      task.due_date = Date.today - 1.day
      task.validate
      expect(task.errors.messages[:due_date].first).
      to include("Date should not be in the past.")
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
end
