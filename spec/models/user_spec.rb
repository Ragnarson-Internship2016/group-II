require 'rails_helper'

RSpec.describe User, type: :model do
  context "With a proper validations setup user" do
    let(:user) { User.create(name: "Wojtek", surname: "Pośpiech", email: "a@a.pl", password: "topsecret") }
    it "should not be valid without a name" do
      user.name = nil
      expect(user).not_to be_valid
    end
    it "should not be valid without a surname" do
      user.surname = nil
      expect(user).not_to be_valid
    end
    it "should be valid with all params provided" do
      expect(user).to be_valid
    end
  end
end
