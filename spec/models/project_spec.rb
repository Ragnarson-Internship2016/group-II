require 'rails_helper'

RSpec.describe Project, type: :model do
  context "invalid params" do
    it "does not save project without title" do
      project = Project.new(date: "20-07-2016", description: "about nothing")
      expect(project.save).to eq(false)
    end

    it "does not save project with too long title" do
      title = "nothing" * 21
      project = Project.new(title: title, date: "20-07-2016", description: "about nothing")
      expect(project.save).to eq(false)
    end
  end

  context "valid params" do
    it "saves projects when all params are given" do
      project = Project.new(title: "nothing", date: "20-07-2016", description: "about nothing")
      expect(project.save).to eq(true)
    end
  end
end
