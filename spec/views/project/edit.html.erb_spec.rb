require 'rails_helper'

RSpec.describe "projects/edit", type: :view do
  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in user
    @project = assign(:project, FactoryGirl.create(:project))
    render
  end

  it "displays page header" do
      expect(rendered).to include("Edit project")
    end

  it "renders link to projects index page" do
    expect(rendered).to have_link(
      "Back", href: "/projects")
  end
end
