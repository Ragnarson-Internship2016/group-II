require 'rails_helper'

RSpec.describe "projects/show", type: :view do
  let(:project) { FactoryGirl.create(:project) }

  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in user
    assign(:project, project)
    render
  end

  it "renders project title" do
    expect(rendered).to include(project.title)
  end

  it "render link to project page" do
    expect(rendered).to have_link("Back", href: "/projects")
  end

  it "render link to edit project page" do
    expect(rendered).to have_link("Edit", href: "/projects")
  end
end
