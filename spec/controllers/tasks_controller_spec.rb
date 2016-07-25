require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:task) { FactoryGirl.create(:task) }
  let(:another_task) { FactoryGirl.create(:task) }
  let(:project) { task.project }
  let(:user) { project.user }

  describe "when user is not authenticated" do
    context "#index" do
      it "redirects to sign in page" do
        get :index, params: { project_id: project.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

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

    context "#update" do
      it "redirects to sign in page" do
        patch :update, params: { project_id: task.project.id, id: task.id, task: FactoryGirl.attributes_for(:task) }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "#create" do
      it "redirects to sign in page" do
        post :create, params: { project_id: project.id, task: FactoryGirl.attributes_for(:task) }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "#mark_as_done" do
      it "redirects to sign in page" do
        put :mark_as_done, params: { project_id: project.id, id: task.id, task: task.attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "#destroy" do
      it "redirects to sign in page" do
        delete :destroy, params: { project_id: project.id, id: task.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context "when user is authenticated" do
    before { sign_in(user) }

    describe "#index" do
      context "with proper params" do
        before { get :index, params: { project_id: project.id } }

        it "fetches tasks that belongs to requested project" do
          expect(assigns(:tasks)).to eq([task])
        end

        it "has a 200 status code" do
          expect(response.status).to eq(200)
        end

        it "redirects to index page" do
          expect(response).to render_template(:index)
        end
      end

      context "with improper params" do
        before { get :index, params: { project_id: "foo" } }

        it "redirects to root path" do
          expect(response).to redirect_to(root_path)
        end

        it "return descriptive flush message" do
          expect(flash[:notice]).to include("Error, wrong params in the request - record could not be found")
        end
      end
    end

    describe "#show" do
      context "with proper params" do
        context "when task and project are associated" do
          before { get :show, params: { project_id: project.id, id: task.id } }

          it "has a 200 status code" do
            expect(response.status).to eq(200)
          end

          it "redirects to project_task show page" do
            expect(response).to render_template(:show)
          end

          it "fetches proper task and assigns it to instance avariable" do
            expect(assigns(:task)).to eql(task)
          end

          it "fetches proper project and assigns it to instance avariable" do
            expect(assigns(:project)).to eql(project)
          end
        end

        context "when task and project are NOT associated " do
          before { get :show, params: { project_id: another_task.project.id, id: task.id } }

          it "redirects to root path if project and task dont match" do
            expect(response).to redirect_to(root_path)
          end

          it "returns proper flush message" do
            expect(flash[:notice]).to include("Error, requested task is not associated with this project")
          end
        end
      end

      context "with improper params" do
        before { get :show, params: { project_id: another_task.project.id, id: "foo" } }

        it "redirects to root path" do
          expect(response).to redirect_to(root_path)
        end

        it "return descriptive flush message" do
          expect(flash[:notice]).to include("Error, wrong params in the request - record could not be found")
        end
      end
    end

    describe "#new" do
      context "with proper params" do
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

      context "with improper params" do
        before { get :new, params: { project_id: Project.last.id + 1 } }

        it "redirects to root path" do
          expect(response).to redirect_to(root_path)
        end

        it "return descriptive flush message" do
          expect(flash[:notice]).to include("Error, wrong params in the request - record could not be found")
        end
      end
    end

    describe "#edit" do
      context "with proper params" do
        context "when task and project are associated" do
          before { get :edit, params: { project_id: project.id, id: task.id } }

          it "has a 200 status code" do
            expect(response.status).to eq(200)
          end

          it "Renders edit template" do
            expect(response).to render_template(:edit)
          end

          it "fetches proper task and assigns it to instance avariable" do
            expect(assigns(:task)).to eql(task)
          end

          it "fetches proper project and assigns it to instance avariable" do
            expect(assigns(:project)).to eql(project)
          end
        end

        context "when task and project are NOT associated" do
          before { get :edit, params: { project_id: another_task.project.id, id: task.id } }

          it "redirects to root path if project and task dont match" do
            expect(response).to redirect_to(root_path)
          end

          it "returns proper flush message" do
            expect(flash[:notice]).to include("Error, requested task is not associated with this project")
          end
        end
      end

      context "with improper params" do
        before { get :edit, params: { project_id: Project.last.id + 1, id: "foo" } }

        it "redirects to root path" do
          expect(response).to redirect_to(root_path)
        end

        it "return descriptive flush message" do
          expect(flash[:notice]).to include("Error, wrong params in the request - record could not be found")
        end
      end
    end

    describe "#mark_as_done" do
      context "with valid params" do

        context "when task and project are associated" do
          before { put :mark_as_done, params: { project_id: project.id, id: task.id } }

          it "redirects_to project_tasks page" do
            expect(response).to redirect_to(project_tasks_path)
          end

          it "returns successful flush message" do
            expect(flash[:notice]).to include("Task marked as DONE")
          end

          it "updates done field to true" do
            expect(assigns(:task).done).to eql(true)
          end
        end

        context "when task and project are NOT associated" do
          before { put :mark_as_done, params: { project_id: project.id, id: another_task.id } }

          it "redirects to root path if project and task dont match" do
            expect(response).to redirect_to(root_path)
          end

          it "returns proper flush message" do
            expect(flash[:notice]).to include("Error, requested task is not associated with this project")
          end
        end
      end

      context "with invalid params" do
        before { put :mark_as_done, params: { project_id: project.id, id: "foo" } }

        it "redirects to root path" do
          expect(response).to redirect_to(root_path)
        end

        it "return descriptive flush message" do
          expect(flash[:notice]).to include("Error, wrong params in the request - record could not be found")
        end
      end
    end

    describe "#create" do
      context "with valid params" do
        before { post :create, params: { project_id: project.id, task: FactoryGirl.attributes_for(:task) } }

        it "creates task in memory initialized with a gives params" do
          expect(assigns(:task)).to eql(Task.last)
        end

        it "redirects to task show page after it was successfully saved in database" do
          expect(response).to redirect_to(project_task_path(Task.last.project, Task.last))
        end

        it "shows successful flush message" do
          expect(flash[:notice]).to include("Task was successfully created")
        end
      end

      context "with invalid params" do
        before { post :create, params: { project_id: "foo", task: { a: "foo" } } }

        it "redirects to root path" do
          expect(response).to redirect_to(root_path)
        end

        it "return descriptive flush message" do
          expect(flash[:notice]).to include("Error, wrong params in the request - record could not be found")
        end
      end
    end

    describe "#update" do
      context "with valid params" do
        context "when task and project are associated" do
          let!(:task_attr) { FactoryGirl.attributes_for(:task, title: "Old man and the sea") }
          before { patch :update, params: { project_id: task.project.id, id: task.id, task: task_attr } }

          it "updates record" do
            expect(assigns(:task).title).to eql(task_attr[:title])
          end

          it "redirects to task show page" do
            expect(response).to redirect_to(project_task_path(task.project.id, task.id))
          end

          it "returns proper flush message" do
            expect(flash[:notice]).to include("Task was successfully updated.")
          end
        end

        context "when task and project are NOT associated" do
          before { patch :update, params: { project_id: task.project.id, id: another_task.id, task: FactoryGirl.attributes_for(:task) } }

          it "redirects to root path if project and task dont match" do
            expect(response).to redirect_to(root_path)
          end

          it "returns proper flush message" do
            expect(flash[:notice]).to include("Error, requested task is not associated with this project")
          end
        end
      end

      context "with invalid params" do
        before { patch :update, params: { project_id: task.project.id, id: "foo", task: FactoryGirl.attributes_for(:task) } }

        it "redirects to root path" do
          expect(response).to redirect_to(root_path)
        end

        it "return descriptive flush message" do
          expect(flash[:notice]).to include("Error, wrong params in the request - record could not be found")
        end
      end
    end

    describe "#destroy" do
      context "with valid params" do
        context "when task and project are associated" do

          it "destroys record", skip_before: true do
            expect {
              delete :destroy, params: { project_id: task.project.id, id: task.id }
            }.to change { Task.all.size }.by(-1)
          end

          it "redirects to project tasks page" do
            delete :destroy, params: { project_id: task.project.id, id: task.id }
            expect(response).to redirect_to(project_tasks_path(project))
          end

          it "returns proper flush message" do
            delete :destroy, params: { project_id: task.project.id, id: task.id }
            expect(flash[:notice]).to include("Task was successfully destroyed.")
          end
        end

        context "when task and project are NOT associated" do
          before { delete :destroy, params: { project_id: task.project.id, id: another_task.id } }

          it "redirects to root path if project and task dont match" do
            expect(response).to redirect_to(root_path)
          end

          it "returns proper flush message" do
            expect(flash[:notice]).to include("Error, requested task is not associated with this project")
          end
        end
      end

      context "with invalid params" do
        before { delete :destroy, params: { project_id: task.project.id, id: "foo" } }

        it "redirects to root path" do
          expect(response).to redirect_to(root_path)
        end

        it "return descriptive flush message" do
          expect(flash[:notice]).to include("Error, wrong params in the request - record could not be found")
        end
      end
    end
  end
end
