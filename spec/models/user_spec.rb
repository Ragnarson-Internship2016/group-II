require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) { FactoryGirl.build(:user) }

  context "With a proper validations setup user" do
    it "is valid with all params provided" do
      expect(user).to be_valid
    end
  end

  context "With improper validations setup user" do
    it "is not valid without a name" do
      user.name = nil
      expect(user).not_to be_valid
    end

    it "is not valid without a surname" do
      user.surname = nil
      expect(user).not_to be_valid
    end
  end
end
