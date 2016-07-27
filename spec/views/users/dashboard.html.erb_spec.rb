require 'rails_helper'

RSpec.describe "users/dashboard.html.erb", type: :view do
  let(:project) { FactoryGirl.create(:project) }
  let(:user) { project.user }

  let(:tasks) do
    3.times.collect do
      FactoryGirl.create(
        :assigned_task,
        project: project,
        participants: [user]
      )
    end
  end

  let(:done_task) do
    FactoryGirl.create(
      :assigned_task,
      title: "Done task",
      project: project,
      participants: [user],
      done: true
    )
  end

  before do
    sign_in(user)

    assign(:user_tasks, tasks.group_by(&:project))
    assign(:user_projects, [project])

    render
  end

  it "renders user's tasks' titles" do
    titles = tasks.map(&:title)

    expect(rendered).to include(*titles)
  end

  it "renders user's tasks' descriptions" do
    descriptions = tasks.map(&:description)

    expect(rendered).to include(*descriptions)
  end

  it "renders proper formatted user's tasks' due dates" do
    formatted_due_dates = tasks.map do |task|
      task.due_date.to_formatted_s(:short)
    end

    expect(rendered).to include(*formatted_due_dates)
  end

  it "doesn't render user's done tasks" do
    expect(rendered).not_to include(done_task.title)
  end

  it "renders user's projects' titles" do
    expect(rendered).to include(project.title)
  end
end
