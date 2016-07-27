require 'rails_helper'

RSpec.describe UserTasksController, type: :controller do
  let(:project) { FactoryGirl.create(:project) }
  let(:user) { project.user }
  let(:contributor) { project.contributors.create(FactoryGirl.attributes_for(:user)) }
  let(:task) { project.tasks.create(FactoryGirl.attributes_for(:task)) }
  let(:non_participant) { FactoryGirl.create(:user) }

  context "when user is logged" do
    before do
      sign_in(user)
    end

    context "with proper params" do
      describe "#assign" do
        before do
          sign_in(signed_user)
          post :assign, params: { project_id: task.project.id, id: task.id }
        end

        context "when signed in as project contributor" do
          let(:signed_user) { contributor }

          it "assigns task to the user" do
            expect(assigns(:user_task)).to eql(UserTask.last)
          end

          it "returns flash success message" do |variable|
            expect(flash[:notice]).to include("Task successfully assigned.")
          end
        end

        context "when signed in as non participant" do
          let(:signed_user) { non_participant }

          it "returns forbidden status" do
            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      describe "#leave" do
        before do
          sign_in(signed_user)
          UserTask.create(user: signed_user, task: task)
        end

        context "when signed in as project contributor" do
          let(:signed_user) { contributor }

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

        context "when signed in as non participant" do
          let(:signed_user) { non_participant }

          it "returns forbidden status" do
            delete :leave, params: { project_id: task.project.id, id: task.id }
            expect(response).to have_http_status(:forbidden)
          end
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
