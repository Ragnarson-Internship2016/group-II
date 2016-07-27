require 'rails_helper'

RSpec.describe UserProjectsController, type: :controller do
  let!(:project) { FactoryGirl.create(:project) }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:project_contributor) { project.contributors.create(FactoryGirl.attributes_for(:user)) }

  describe "#create" do
    context "when user is logged" do
      before { sign_in(project_contributor) }

      context "when user is project manager" do
        before { sign_in(project.user) }

        context "with valid params" do
          before do
            post :create, params: { project_id: project.id, user_id: user.id }
          end

          it "returns http success" do
            expect(response).to have_http_status(:found)
          end

          it "returns flash success message" do |variable|
            expect(flash[:notice]).to include("User successfully assigned.")
          end
        end

        context "with invalid params" do
          it "redirects to root" do
            post :create, params: { project_id: "foo", user_id: user.id }
            expect(response).to redirect_to(root_url)
          end
        end
      end

      context "when user is not project manager" do
        after do
          sign_out(project.user)
        end

        it "returns flash error message of addition" do
          post :create, params: { project_id: project.id, user_id: user.id }
          expect(flash[:notice]).to include("You cannot add anyone to project if you did not create it.")
        end
      end
    end
  end

  describe "#destroy" do
    before do
      UserProject.create(user: user, project: project)
    end

    context "when user is logged" do
      before { sign_in(project_contributor) }

      context "when user is project manager" do
        before { sign_in(project.user) }

        context "with valid params" do
          it "removes project assignment" do
            expect {
              delete :destroy, params: { project_id: project.id, user_id: user.id }
            }.to change { UserProject.count } .by(-1)
          end

          it "returns flash successfully removed message" do
            delete :destroy, params: { project_id: project.id, user_id: user.id }
            expect(flash[:notice]).to include("User assignment was removed.")
          end
        end
      end

      context "when user is not project manager" do
        after do
          sign_out(project.user)
        end

        it "returns flash error message of deletion" do
          delete :destroy, params: { project_id: project.id, user_id: user.id }
          expect(flash[:notice]).to include("You cannot remove anyone from project if you did not create it.")
        end
      end
    end

    context "when user is not logged" do
      after do
        sign_out(project_contributor)
      end

      it "redirects to sign in" do
        post :create, params: { project_id: project.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
