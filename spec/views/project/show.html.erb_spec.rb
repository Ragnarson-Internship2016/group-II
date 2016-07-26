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
end
