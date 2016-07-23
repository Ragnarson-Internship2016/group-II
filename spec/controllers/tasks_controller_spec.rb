require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:task) { FactoryGirl.create(:task) }
  let(:another_task) { FactoryGirl.create(:task) }
  let(:project) { task.project }
  let(:user) { project.user }

  context "when user is authenticated" do
    before do
      sign_in(user)
    end

    context "with proper params" do
      context "#show" do
        context "when task and project are associated " do
          let(:params) { { project_id: project.id, id: task.id } }

          before do
            get :show, params: params
          end

          it "has a 200 status code" do
            expect(response.status).to eq(200)
          end

          it "redirects to project_task show page" do
            expect(response).to render_template(:show)
          end

          it "fetches proper task and assigns it to instance avariable" do
            expect(assigns(:task)).to eql(Task.last)
          end

          it "fetches proper project and assigns it to instance avariable" do
            expect(assigns(:project)).to eql(Project.last)
          end
        end

        context "when task and project are not associated " do
          before { get :show, params: { project_id: another_task.project.id, id: task.id } }

          it "redirects to root path if project and task dont match" do
            expect(response).to redirect_to(root_path)
          end

          it "returns proper flush message" do
            expect(flash[:notice]).to include("Params don't match")
          end
        end
      end

      context "#new" do
        before { get :new, params: { project_id: project.id } }

        it "creates(in memory) and assigns to the instance variable new task" do
          expect(assigns(:task)).to be_a_new(Task)
        end

        it "renders new template" do
          expect(response).to render_template(:new)
        end
        it "has a 200 status code" do
          expect(response.status).to eq(200)
        end
      end

      context "#edit" do
        context "when task and project are associated " do

          let(:params) { { project_id: project.id, id: task.id } }

          before do
            get :edit, params: params
          end

          it "has a 200 status code" do
            expect(response.status).to eq(200)
          end

          it "redirects to project_task show page" do
            expect(response).to render_template(:edit)
          end

          it "fetches proper task and assigns it to instance avariable" do
            expect(assigns(:task)).to eql(Task.last)
          end

          it "fetches proper project and assigns it to instance avariable" do
            expect(assigns(:project)).to eql(Project.last)
          end

        end
        context "when task and project are associated " do

        end
      end
    end

    context "with improper params" do
      context "#show" do
        before { get :show, params: { project_id: another_task.project.id, id: "foo" } }

        it "redirects to root path" do
          expect(response).to redirect_to(root_path)
        end

        it "return descriptive flush message" do
          expect(flash[:notice]).to include("Error, wrong params in the request - record could not be found")
        end
      end
      context "#new" do
        before { get :new, params: { project_id: 123 } }

        it "redirects to root path" do
          expect(response).to redirect_to(root_path)
        end

        it "return descriptive flush message" do
          expect(flash[:notice]).to include("Error, wrong params in the request - record could not be found")
        end
      end

      context "#edit" do
        before { get :edit, params: { project_id: 123, id: "foo" } }

        it "redirects to root path" do
          expect(response).to redirect_to(root_path)
        end

        it "return descriptive flush message" do
          expect(flash[:notice]).to include("Error, wrong params in the request - record could not be found")
        end
      end
    end

    after do
      sign_out(user)
    end
  end

  context "when user is not authenticated" do
    context "#show" do
      it "redirects to sign in page" do
        get :show, params: { project_id: task.project.id, id: task.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context "#new" do
      it "redirects to sign in page" do
        get :new, params: { project_id: project.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context "#edit" do
      it "redirects to sign in page" do
        get :edit, params: { project_id: task.project.id, id: task.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
