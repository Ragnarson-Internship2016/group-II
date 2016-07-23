require 'rails_helper'

RSpec.describe UserTasksController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:task) { FactoryGirl.create(:task) }

  context "when user is logged" do
    before do
      sign_in(user)
    end

    context "with proper params" do
      context "#assign" do
        before do
          post :assign, params: { project_id: task.project.id, id: task.id }
        end

        it "assigns task to the user" do
          expect(assigns(:user_task)).to eql(UserTask.last)
        end

        it "returns flash success message" do |variable|
          expect(flash[:notice]).to include("Task successfully assigned.")
        end
      end

      context "#leave" do
        before do
          UserTask.create(user: user, task: task)
        end

        it "removes task assignment" do
          expect {
            delete :leave, params: { project_id: task.project.id, id: task.id }
          }.to change { UserTask.all.size } .by(-1)
        end

        it "returns flash successfully removed from task assignment" do
          delete :leave, params: { project_id: task.project.id, id: task.id }
          expect(flash[:notice]).to include("Task assigment was removed.")
        end
      end
    end

    context "with not valid params" do
      it "redirects to tasks index" do
        post :assign, params: { project_id: task.project.id, id: "foo"}
        expect(response).to redirect_to(project_tasks_path)
      end

      it "returns parameters' error in flash message" do
        delete :leave, params: { project_id: task.project.id, id: "foo"}
        expect(flash[:notice]).to include("Unable to find requested task.")
      end
    end

    after do
      sign_out(user)
    end
  end

  context "when user is not logged" do
    it "redirects to sign in" do
      post :assign, params: { project_id: task.project.id, id: task.id }
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
