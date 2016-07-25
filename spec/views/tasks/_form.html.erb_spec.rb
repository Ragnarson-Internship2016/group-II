require "rails_helper"

RSpec.describe "tasks/_form", type: :view do
  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in(user)

    render
  end

  it "contains correct url in form" do
    p rendered
  end

  after do
    sign_out(user)
  end
end
