require 'rails_helper'

RSpec.describe "projects/index", type: :view do
  let(:projects) do
  3.times.collect { FactoryGirl.create(:project) }
end
  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in user
    assign(:projects, projects)
    render
  end



describe "rendering text directly" do
  it "displays the given text" do

    expect(rendered).to include(projects[0].title)
  end
end

  it "renders projects titles" do
    expect(rendered).to include(projects[0].title)
    expect(rendered).to include(projects[1].title)
    expect(rendered).to include(projects[2].title)
  end

  it "renders link to edit project" do
    expect(rendered).to have_link(
      "Edit",
      href: "/projects/#{projects[0].id}/edit"
    )
  end

  it "renders link to destroy project" do
    expect(rendered).to have_link(
      "Destroy", href: "/projects/#{projects[0].id}"
    )
  end

  it "does not render link to edit project" do
    expect(rendered).not_to have_link(
      "Edit", href: "/projects/#{projects[1].id}/edit"
    )
  end

  it "does not render link to destroy project" do
    expect(rendered).not_to have_link(
      "Destroy", href: "/projects/#{project[1].id}"
    )
  end

  it "renders link to new project page" do
    expect(rendered).to have_link(
      "New project", href: "/projects/new"
    )
  end
end