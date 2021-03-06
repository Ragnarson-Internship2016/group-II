require 'rails_helper'

RSpec.describe "projects/new", type: :view do
  let(:user) { FactoryGirl.create(:user) }
 
  before do
    sign_in user
    @project = assign(:project, FactoryGirl.create(:project))
    render
  end

  it "display page header" do
    expect(rendered).to include("Create new project")
  end

  it "renders link to tasks index" do
    expect(rendered).to have_link("Back", href: "/projects")
  end
end
