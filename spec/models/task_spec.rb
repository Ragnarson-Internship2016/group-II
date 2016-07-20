require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:title) { "Short text" }
  let(:description) { "Long text" }
  let(:due_date) { "11-11-1999" } 
  
  context "when valid params" do
    it "saves task with all params and without done status" do
      task = Task.new(title: title, description: description, due_date: due_date)
      expect(task.save).to eq(true)
    end

    it "saves task with all params and true done status" do
      task = Task.new(title: title, description: description, due_date: due_date, done: true)
      expect(task.save).to eq(true)
    end
  end

  context "when invalid params" do
    it "does not save task without title" do
      task = Task.new(title: nil, description: description, due_date: due_date)
      expect(task.save).to eq(false)
    end

    it "does not save task without description" do
      task = Task.new(title: title, description: nil, due_date: due_date)
      expect(task.save).to eq(false)
    end

    it "does not save task without date" do
      task = Task.new(title: title, description: description, due_date: nil)
      expect(task.save).to eq(false)
    end
  end
end
