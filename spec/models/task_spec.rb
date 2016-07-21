require 'rails_helper'

RSpec.describe Task, type: :model do
  subject(:employee1) { FactoryGirl.create(:user) }
  subject(:employee2) { FactoryGirl.create(:user) }
  subject(:task) { FactoryGirl.create(:task) }

  context "with valid task params" do
    it "it is valid with all task params" do
      expect(task).to be_valid
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

    it "is not valid with a past_date" do
      task.due_date = Date.today - 1.day
      task.validate
      expect(task.errors.messages[:due_date].first).
      to include("Date should not be in the past.")
    end
  end

  context "with properly setup many to many association user-task" do
    it "returns empty participants list if noone is aggined" do
      expect(task.participants).to be_empty
    end

    it "returns array of prticipants" do
      UserTask.create(user: employee1, task: task)
      UserTask.create(user: employee2, task: task)
      expect(task.participants.to_a).to eql([employee1, employee2])
    end
  end
end
