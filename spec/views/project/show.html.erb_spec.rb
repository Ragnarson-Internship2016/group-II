require 'rails_helper'

RSpec.describe "projects/show", type: :view do
  let(:current_user) { FactoryGirl.create(:user) }

  let(:project) { FactoryGirl.create(:project_with_tasks) }
  let(:active_tasks) { project.tasks.not_done }
  let(:done_tasks) { 2.times.collect { FactoryGirl.create(:task, done: true, project: project)} }
  let(:events) { 2.times.collect { FactoryGirl.create(:event, project: project) }}

  before do
    assign(:project, project)
    assign(:active_tasks, active_tasks)
    assign(:done_tasks, done_tasks)
    assign(:events, events)

    allow(view).to receive(:current_user) { current_user }

    view.define_singleton_method(:policy) do |project|
      ProjectPolicy.new(current_user, project)
    end

    render
  end

  it "renders project title" do
    expect(rendered).to include(project.title)
  end

  it "renders project description" do
    expect(rendered).to include(project.description)
  end

  describe "renders active tasks'" do
    it "titles" do
      titles = active_tasks.map(&:title)

      expect(rendered).to include(*titles)
    end

    it "descriptions" do
      descriptions = active_tasks.map(&:description)

      expect(rendered).to include(*descriptions)
    end

    it "proper formatted due dates" do
      formatted_due_dates = active_tasks.map do |task|
        task.due_date.to_formatted_s(:short)
      end

      expect(rendered).to include(*formatted_due_dates)
    end
  end

  describe "renders done tasks'" do
    it "titles" do
      titles = done_tasks.map(&:title)

      expect(rendered).to include(*titles)
    end

    it "descriptions" do
      descriptions = done_tasks.map(&:description)

      expect(rendered).to include(*descriptions)
    end

    it "proper formatted due dates" do
      formatted_due_dates = done_tasks.map do |task|
        task.due_date.to_formatted_s(:short)
      end

      expect(rendered).to include(*formatted_due_dates)
    end
  end

  it "renders events' titles" do
    titles = events.map(&:title)

    expect(rendered).to include(*titles)
  end

  it "renders proper formatted events' due dates" do
    formatted_due_dates = events.map do |event|
      event.date.to_formatted_s(:short)
    end

    expect(rendered).to include(*formatted_due_dates)
  end

  it "renders link to new event page" do
    expect(rendered).to have_link(nil, href: "/projects/#{project.id}/events/new")
  end

  context "when signed in as project manager" do
    let(:current_user) { project.user }

    it "renders link to edit project page" do
      expect(rendered).to have_link(
        "Edit",
        href: "/projects/#{project.id}/edit"
      )
    end
  end

  context "when signed in as non-manager" do
    it "does not render link to edit project" do
      expect(rendered).to_not have_link(
        "Edit",
        href: "/projects/#{project.id}/edit"
      )
    end
  end
end
