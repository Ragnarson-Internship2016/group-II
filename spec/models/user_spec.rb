require 'rails_helper'

RSpec.describe User, type: :model do
  context "With a proper validations setup user" do
    before :each do
      @user = User.create(name: "Wojtek", surname: "Pośpiech")
    end
    it "should not be valid without a name" do
      @user.name = nil
      @user.should_not be_valid
    end
    it "should not be valid without a surname" do
      @user.surname = nil
      @user.should_not be_valid
    end
  end
end
