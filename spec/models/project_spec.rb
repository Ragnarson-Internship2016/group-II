require 'rails_helper'

RSpec.describe Project, type: :model do
  context "with invalid params" do
    it "does not save project without title" do
      project = Project.new(date: "20-07-2016", description: "about nothing")
      expect(project).not_to be_valid
    end
  end

  context "with valid params" do
    it "saves projects when all params are given" do
      project = Project.new(title: "nothing", date: "20-07-2016", description: "about nothing")
      expect(project).to be_valid
    end
  end
end
