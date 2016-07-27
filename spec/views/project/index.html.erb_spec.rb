require 'rails_helper'

RSpec.describe "projects/index", type: :view do
  let(:projects) { 2.times.collect { FactoryGirl.create(:project) } }
  let(:project) { projects.first }
  let(:signed_user) {}

  before do
    allow(view).to receive(:current_user) { signed_user }
    view.define_singleton_method(:policy) do |project|
      ProjectPolicy.new(current_user, project)
    end
    assign(:projects, projects)
    render
  end

  it "renders projects titles" do
    expect(rendered).to include(projects[0].title)
    expect(rendered).to include(projects[1].title)
  end

  it "renders link to new project page" do
    expect(rendered).to have_link(
      "New Project", href: "/projects/new")
  end

  context "when signed as project manager" do
    let(:signed_user) { project.user }

    it "renders link to show project" do
      expect(rendered).to have_link(
        "Show",
        href: "/projects/#{project.id}"
      )
    end

    it "renders link to edit project" do
      expect(rendered).to have_link(
        "Edit",
        href: "/projects/#{project.id}/edit"
      )
    end

    it "renders link to destroy project" do
      expect(rendered).to have_link(
        "Destroy",
        href: "/projects/#{project.id}"
      )
    end
  end

  context "when signed as project contributor" do
    let(:signed_user) do
      project.contributors.create(FactoryGirl.attributes_for(:user))
    end

    it "renders link to show project" do
      expect(rendered).to have_link(
        "Show",
        href: "/projects/#{project.id}"
      )
    end

    it "does not render link to edit project" do
      expect(rendered).not_to have_link(
        "Edit",
        href: "/projects/#{project.id}/edit"
      )
    end

    it "does not render link to destroy project" do
      expect(rendered).not_to have_link(
        "Destroy",
        href: "/projects/#{project.id}"
      )
    end
  end

  context "when signed as non participant" do
    let(:signed_user) { FactoryGirl.build(:user) }

    it "does not render link to show project" do
      expect(rendered).not_to have_link(
        "Show",
        href: "/projects/#{project.id}"
      )
    end

    it "does not render link to edit project" do
      expect(rendered).not_to have_link(
        "Edit",
        href: "/projects/#{project.id}/edit"
      )
    end

    it "does not render link to destroy project" do
      expect(rendered).not_to have_link(
        "Destroy",
        href: "/projects/#{project.id}"
      )
    end
  end
end
