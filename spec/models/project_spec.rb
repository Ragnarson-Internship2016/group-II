require "rails_helper"

RSpec.describe Project, type: :model do
  context "with invalid params" do
    it "does not save project without title" do
      project = FactoryGirl.build(:project, title: nil)
      expect(project).not_to be_valid
    end
  end

  context "with valid params" do
    it "saves projects when all params are given" do
      project = FactoryGirl.build(:project)
      expect(project).to be_valid
    end
  end
end
