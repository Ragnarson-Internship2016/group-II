require 'rails_helper'

RSpec.describe "projects/show", type: :view do
  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in user
    @project = assign(:project, FactoryGirl.create(:project))
    @event = assign(:event, FactoryGirl.create(:event))
    @task = assign(:task, FactoryGirl.create(:task))
    render
  end

  it "renders project title" do
    expect(rendered).to include(@project.title)
  end

  it "render link to project page" do
    expect(rendered).to have_link("Back", href: "/projects")
  end

  it "render link to project events page" do
    expect(rendered). to have_link("All events", href: "/projects/#{@event.project_id}/events")
  end

  it "render link to project tasks page" do
    expect(rendered). to have_link("All tasks", href: "/projects/#{@task.project_id}/tasks")
  end
end
