require "rails_helper"

RSpec.describe "tasks/show", type: :view do
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }
  let(:not_finished_task) { FactoryGirl.create(:task, project: project) }
  let(:finished_task) { FactoryGirl.create(:task, project: project, done: true) }

  before { sign_in(user) }

  context "with not finished task" do
    context "when task is not assigned to user" do
      before do
        UserProject.create(user: user, project: project)
        @task = assign(:task, not_finished_task)
        render
      end

      it "renders task title" do
        expect(rendered).to include(@task.title)
      end

      it "renders task description" do
        expect(rendered).to include(@task.description)
      end

      it "renders task deadline date" do
        expect(rendered).to include(@task.due_date.to_s)
      end

      it "renders message 'in progress'" do
        expect(rendered).to include("In progress")
      end

      it "redners link to tasks index" do
        expect(rendered).to have_link(
          "Back",
          href: "/projects/#{project.id}/tasks")
      end

      it "redners link to join task" do
        expect(rendered).to have_link(
          "Join task",
          href: "/projects/#{project.id}/tasks/#{@task.id}/assign")
      end

      it "redners link to edit task" do
        expect(rendered).to have_link(
          "Edit",
          href: "/projects/#{project.id}/tasks/#{@task.id}/edit")
      end

      it "redners link to delete task" do
        expect(rendered).to have_link(
          "Remove",
          href: "/projects/#{project.id}/tasks/#{@task.id}")
      end

      it "redners link to mark task as done" do
        expect(rendered).to have_link(
          "Mark as done",
          href: "/projects/#{project.id}/tasks/#{@task.id}/done")
      end
    end

    context "when task is assigned to user" do
      before do
        UserProject.create(user: user, project: project)
        @task = assign(:task, not_finished_task)
        UserTask.create(user: user, task: @task)
        render
      end

      it "redners link to leave task" do
        expect(rendered).to have_link(
          "Leave task",
          href: "/projects/#{project.id}/tasks/#{@task.id}/leave")
      end
    end
  end

  context "with finished task" do
    before do
      UserProject.create(user: user, project: project)
      @task = assign(:task, finished_task)
      render
    end

    it "renders message 'finished'" do
      expect(rendered).to include("Finished")
    end

    it "does nor redner link to join task" do
      expect(rendered).not_to have_link(
        "Join task",
        href: "/projects/#{project.id}/tasks/#{@task.id}/assign")
    end

    it "does not renderlink to edit task" do
      expect(rendered).not_to have_link(
        "Edit",
        href: "/projects/#{project.id}/tasks/#{@task.id}/edit")
    end

    it "does not redner link to delete task" do
      expect(rendered).to have_link(
        "Remove",
        href: "/projects/#{project.id}/tasks/#{@task.id}")
    end

    it "does not redner link to mark task as done" do
      expect(rendered).not_to have_link(
        "Mark as done",
        href: "/projects/#{project.id}/tasks/#{@task.id}/done")
    end
  end

  after { sign_out(user) }
end
