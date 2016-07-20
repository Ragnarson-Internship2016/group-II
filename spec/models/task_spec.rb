require 'rails_helper'

RSpec.describe Task, type: :model do
  subject(:task) { Task.create(title: "Short text", description: "Long text", due_date: "11-11-1999") }
  
  context "With a proper task validations" do
    it "it is valid with all params provided" do
      expect(task).to be_valid
    end    
  end

  context "With improper task validations" do
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
  end
end
