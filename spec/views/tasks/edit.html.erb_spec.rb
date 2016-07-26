require "rails_helper"

RSpec.describe "tasks/edit", type: :view do
  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in(user)
    @task = assign(:task, FactoryGirl.create(:task))
    render
  end

  it "contains correct url in form" do
    expect(rendered).
    to have_selector('form[action="%s"][method="%s"]' % [
        "/projects/#{@task.project_id}/tasks/#{@task.id}",
        "post"
      ])
  end

  it "renders link to tasks index" do
    expect(rendered).to have_link(
      "Back",
      href: "/projects/#{@task.project.id}/tasks")
  end

  after do
    sign_out(user)
  end
end
