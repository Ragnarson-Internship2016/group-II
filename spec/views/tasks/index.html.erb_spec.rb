require "rails_helper"

RSpec.describe "tasks/index", type: :view do
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }
  let(:tasks) do
    3.times.collect { FactoryGirl.create(:task, project: project) }
  end

  before do
    sign_in(user)
    UserProject.create(user: user, project: project)
    tasks.each do |task|
      UserTask.create(user: user, task: task)
    end
    assign(:tasks, tasks)
    assign(:project, project)
    render
  end

  it "renders tasks' titles" do
    expect(rendered).to include(tasks[0].title)
    expect(rendered).to include(tasks[1].title)
    expect(rendered).to include(tasks[2].title)
  end

    it "renders tasks' descriptions" do
    expect(rendered).to include(tasks[0].description)
    expect(rendered).to include(tasks[1].description)
    expect(rendered).to include(tasks[2].description)
  end

    it "renders tasks' deadlines" do
    expect(rendered).to include(tasks[0].due_date.to_s)
    expect(rendered).to include(tasks[1].due_date.to_s)
    expect(rendered).to include(tasks[2].due_date.to_s)
  end

  it "renders links to tasks' shows" do
    expect(rendered).to
      have_link(
        "Show",
        href: "/projects/#{project.id}/tasks/#{tasks[0].id}")
    expect(rendered).to
      have_link(
        "Show",
        href: "/projects/#{project.id}/tasks/#{tasks[1].id}")
    expect(rendered).to
      have_link(
        "Show",
        href: "/projects/#{project.id}/tasks/#{tasks[2].id}")
  end

  it "renders link to add new task" do
    expect(rendered).to
      have_link(
        "Create new task",
        href: "/projects/#{project.id}/tasks/new")
  end

  it "renders links with class button" do
    expect(rendered).to have_css("a.btn")
  end

  after do
    sign_out(user)
  end
end
