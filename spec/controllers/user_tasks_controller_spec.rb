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
          expect(flash[:notice]).to include("Successfully assigned!")
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
          expect(flash[:notice]).to include("You are no logner assigned to this task!")
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
        expect(flash[:notice]).to include( "Error, wrong parameters in the request!")
      end
    end

    after do
      sign_out(user)
    end
  end

  context "when user is not logged" do
    context "#assign" do
      it "returns error in flash message" do
        post :assign, params: { project_id: task.project.id, id: task.id }
        expect(flash[:notice]).to include("Error, cannot assigned!")
      end

      it "redirects to task show" do
        post :assign, params: { project_id: task.project.id, id: task.id }
        expect(response).to redirect_to([task.project, task])
      end
    end

    context "#leave" do
      it "returns error in flash message" do
        delete :leave, params: { project_id: task.project.id, id: task.id }
        expect(flash[:notice]).to include("Error, cannot remove assignment!")
      end
    end
  end

end
