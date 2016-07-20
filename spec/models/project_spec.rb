require 'rails_helper'

RSpec.describe Project, type: :model do
  context "invalid params" do
    it "does not save project without title" do
      project = Project.new(id:1, date: "20-07-2016", description: "o niczym")
      expect(project.save).to eq(false)
    end

    it "does not save project with too long title" do
      project = Project.new(id:2, title: "projekt o bardzo długim, długim, długim, długim, długim, długim, długim, długim za długim tytule o kilka znaków", date: "20-07-2016", description: "o niczym")
      expect(project.save).to eq(false)
    end
  end

  context "valid params" do
    it "saves projects when all params are given" do
      project = Project.new(id:1, title: "tytuł", date: "20-07-2016", description: "o niczym")
      expect(project.save).to eq(true)
    end
  end
end
