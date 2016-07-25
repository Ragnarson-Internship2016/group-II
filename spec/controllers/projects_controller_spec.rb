require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let!(:project) { FactoryGirl.create(:project) }
  let(:other_project) { FactoryGirl.build(:project) }
  let(:user) { project.user }

  context "when user is not authenticated" do
    context "#index" do
      it "redirects to sign in page" do
        get :index, params: { id: project.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "#show" do
      it "redirects to sign in page" do
        get :show, params: { id: project.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "#new" do
      it "redirects to sign in page" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "#edit" do
      it "redirects to sign in page" do
        get :edit, params: { id: project.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "#update" do
      it "redirects to sign in page" do
        patch :update, params: { id: project.id, project: FactoryGirl.attributes_for(:project) }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "#create" do
      it "redirects to sign in page" do
        post :create, params: { project: FactoryGirl.attributes_for(:project) }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "#destroy" do
      it "redirects to sign in page" do
        delete :destroy, params: { id: project.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context "when user is authenticated" do
    before { sign_in(user) }

    describe "GET #index" do
      before { get :index, params: { id: project.id } }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "assigns all tasks to the instance variable" do
        expect(assigns(:projects)).to eq(Project.all)
      end
      it "renders template index" do
        expect(response).to render_template(:index)
      end
    end

    describe "GET #managed_projects" do
      before { get :managed_projects }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "assigns all tasks to the instance variable" do
        expect(assigns(:projects)).to eq(user.managed_projects)
      end
    end


    describe "GET #contributed_projects" do
      before { get :contributed_projects }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "assigns all tasks to the instance variable" do
        expect(assigns(:projects)).to eq(user.contributed_projects)
      end
    end


    describe "GET #show" do
      context "with proper params" do
        before { get :show, params: { id: project.id } }

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "fetches proper project" do
          expect(assigns(:project)).to eq(Project.find(project.id))
        end

        it "renders show template" do
          expect(response).to render_template(:show)
        end
      end

      context "with improper params" do
        it "sets status to 404" do
          get :show, params: { id: "foo" }
          expect(response.status).to eq(404)
        end
      end
    end

    describe "GET #new" do
      before { get :new }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "renders new template" do
        expect(response).to render_template(:new)
      end

      it "assigns new project to the variable" do
        expect(assigns(:project)).to be_a_new(Project)
      end
    end

    describe "  POST #create" do
      before { post :create, params: { project: other_project.attributes } }

      it "assign new project" do
        expect(assigns(:project)).to eq(Project.last)
      end

      it "redirects to projects show page" do
        expect(response).to redirect_to assigns(:project)
      end

      it "returns http success" do
        expect(response).to have_http_status(:found)
      end

      it "return proper flush message" do
        expect(flash[:notice]).to include("Poject was successfully created.")
      end

      it "creator of the project is automatically assigned to the UserProject table that represents its contributors" do
        expect(user.contributed_projects).to include(assigns(:project))
      end
    end

    describe "GET #edit" do
      before { get :edit, params: { id: project.id } }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "assigns a new project variabe in memory" do
        expect(assigns(:project)).to eq(Project.find(project.id))
      end

      it "renders edit template" do
        expect(response).to render_template(:edit)
      end
    end

    describe "PUT #update" do
      let!(:attr) { FactoryGirl.attributes_for(:project, title: "Old man and the sea") }
      before { put :update, params: { id: project.id, project: attr } }

      it "returns http success" do
        expect(response).to have_http_status(:found)
      end

      it "updates record" do
        expect(assigns(:project).title).to eql(attr[:title])
      end

      it "redirects to task show page" do
        expect(response).to redirect_to project
      end

      it "returns proper flush message" do
        expect(flash[:notice]).to include("Poject was successfully updated.")
      end
    end

    describe "DELETE #destroy" do
      before { delete :destroy, params: { id: project.id } }

      it "returns http success" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to projects url" do
        expect(response).to redirect_to projects_path
      end

      it "deletes the requested record " do
        expect(Project.all).to be_empty
      end

      it "displays roper flush message" do
        expect(flash[:notice]).to include("Poject was successfully destroyed.")
      end
    end
  end
end
