require 'rails_helper'

RSpec.describe UserTask, type: :model do
  let(:employee) { FactoryGirl.create(:user) }
  let(:task) { FactoryGirl.create(:task) }

  context "with valid parameters" do
    it "assigns employee to the task" do
      expect(UserTask.create(user: employee, task: task)).to be_valid
    end

    it "does not assigned the same person to the same task twice" do
      expect {
        2.times { UserTask.create(user: employee, task: task) }
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  context "with invalid parameters" do
    it "does not add if user is not provided" do
      expect(UserTask.create(task: task)).not_to be_valid
    end

    it "does not add if task is not provided" do
      expect(UserTask.create(user: employee)).not_to be_valid
    end
  end
end
