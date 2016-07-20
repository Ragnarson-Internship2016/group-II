require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:title) { "Short text" }
  let(:description) { "Long text" }
  let(:due_date) { "11-11-1999" } 
  let(:status) { true }

  context "valid params" do
    it "save task with all params" do
      task = Task.new(title: title, description: description, due_date: due_date, status: true)
      expect(task.save).to eq(true)
    end
  end

  context "invalid params" do
    it "does not save task without title" do
      task = Task.new(title: nil, description: description, due_date: due_date, status: true)
      expect(task.save).to eq(false)
    end
    it "does not save task without description" do
      task = Task.new(title: title, description: nil, due_date: due_date, status: true)
      expect(task.save).to eq(false)
    end
    it "does not save task without date" do
      task = Task.new(title: title, description: description, due_date: nil, status: true)
      expect(task.save).to eq(false)
    end
    it "does not save task without status" do
      task = Task.new(title: title, description: description, due_date: due_date, status: nil)
      expect(task.save).to eq(false)
    end
  end
end