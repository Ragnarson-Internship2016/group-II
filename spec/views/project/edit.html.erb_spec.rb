require 'rails_helper'

RSpec.describe "projects/edit", type: :view do

  let(:project) { FactoryGirl.create(:project) }
  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in user
  end

  it "contains form to correct url" do
    expect(rendered).to have_selector('form[action="%s"][method="%s"]' % [
      "/projects/#{@project_id}",
      "post"
    ])
  end
end
