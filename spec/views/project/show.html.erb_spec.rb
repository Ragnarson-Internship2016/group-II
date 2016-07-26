require 'rails_helper'

RSpec.describe "projects/show", type: :view do
  let(:current_user) { FactoryGirl.create(:user) }

  before do
    @project = assign(:project, FactoryGirl.create(:project))
    @event = assign(:event, FactoryGirl.create(:event))
    @task = assign(:task, FactoryGirl.create(:task))
    allow(view).to receive(:current_user) { current_user }
    view.define_singleton_method(:policy) do |project|
      ProjectPolicy.new(current_user, project)
    end
    render
  end

  it "renders project title" do
    expect(rendered).to include(@project.title)
  end

  it "renders project description" do
    expect(rendered).to include(@project.description)
  end

  it "renders formatted project due date" do
    expect(rendered).to include(@project.date.strftime("%d/%m/%Y"))
  end

  it "render link to project page" do
    expect(rendered).to have_link("Back", href: "/projects")
  end

  it "render link to project events page" do
    expect(rendered). to have_link("All events", href: "/projects/#{@project.id}/events")
  end

  it "render link to project tasks page" do
    expect(rendered). to have_link("All tasks", href: "/projects/#{@project.id}/tasks")
  end

  context "when signed in as project manager" do
    let(:current_user) { @project.user }

    it "renders link to edit project" do
      expect(rendered).to have_link(
        "Edit",
        href: "/projects/#{@project.id}/edit"
      )
    end
  end

  context "when signed in as non-manager" do
    it "does not render link to edit project" do
      expect(rendered).to_not have_link(
        "Edit",
        href: "/projects/#{@project.id}/edit"
      )
    end
  end
end
