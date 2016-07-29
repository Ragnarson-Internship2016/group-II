require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let!(:project) { FactoryGirl.create(:project) }
  let(:other_project) { FactoryGirl.build(:project) }
  let(:user) { project.user }
  let(:non_participant) { FactoryGirl.create(:user) }
  let(:contributor) { project.contributors.create(FactoryGirl.attributes_for(:user)) }

  context "when user is not authenticated" do
    context "#index" do
      it "redirects to sign in page" do
        get :index
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

    context "#link_contributors" do
      it "redirects to sign in page" do
        get :link_contributors, params: { id: project.id }
        expect(response).to redirect_to(new_user_session_path)
      end
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

      it "assigns contributed projects to the instance variable" do
        expect(assigns(:contributed)).to eq(user.contributed_projects.all)
      end

      it "assigns managed projects to the instance variable" do
        expect(assigns(:managed)).to eq(user.managed_projects.all)
      end

      it "renders template index" do
        expect(response).to render_template(:index)
      end
    end

    describe "GET #managed" do
      before { get :managed }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "assigns all projects to the instance variable" do
        expect(assigns(:projects)).to eq(user.managed_projects)
      end
    end

    describe "GET #contributed_projects" do
      before { get :contributed }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "assigns all projects to the instance variable" do
        expect(assigns(:projects)).to eq(user.contributed_projects)
      end
    end

    describe "GET #show" do
      context "when signed is as project manager" do
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

        context "with not existing project id" do
          it "redirects to root" do
            expect(get :show, params: { id: "foo" }).to redirect_to(root_url)
          end
        end
      end

      context "when signed in as project contributor" do
        before do
          sign_in(contributor)
          get :show, params: { id: project.id }
        end

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "fetches proper project" do
          expect(assigns(:project)).to eq(Project.find(project.id))
        end
      end

      context "when signes in as non-participant" do
        before do
          sign_in(non_participant)
          get :show, params: { id: project.id }
        end

        it "returns forbidden status" do
          expect(response).to have_http_status(:forbidden)
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

    describe "POST #create" do
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
      before do
        sign_in(signed_user)
        get :edit, params: { id: project.id }
      end

      context "when signed in as project manager" do
        let(:signed_user) { project.user }

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

      context "when signed in as contributor" do
        let(:signed_user) { contributor }

        it "returns forbidden status" do
          expect(response).to have_http_status(:forbidden)
        end
      end

      context "when signed in as non-participant" do
        let(:signed_user) { non_participant }

        it "returns forbidden status" do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    describe "PUT #update" do
      let(:attr) { FactoryGirl.attributes_for(:project, title: "Old man and the sea") }
      before do
        sign_in(signed_user)
        put :update, params: { id: project.id, project: attr }
      end

      context "when signed in as project manager" do
        let(:signed_user) { project.user }

        it "returns http success" do
          expect(response).to have_http_status(:found)
        end

        it "updates record" do
          expect(assigns(:project).title).to eql(attr[:title])
        end

        it "redirects to project show page" do
          expect(response).to redirect_to project
        end

        it "returns proper flush message" do
          expect(flash[:notice]).to include("Poject was successfully updated.")
        end
      end

      context "when signed in as contributor" do
        let(:signed_user) { contributor }

        it "returns forbidden status" do
          expect(response).to have_http_status(:forbidden)
        end
      end

      context "when signed in as non-participant" do
        let(:signed_user) { non_participant }

        it "returns forbidden status" do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    describe "DELETE #destroy" do
      before do
        sign_in(signed_user)
        delete :destroy, params: { id: project.id }
      end

      context "when signed in as project manager" do
        let(:signed_user) { project.user }

        it "returns http success" do
          expect(response).to have_http_status(:found)
        end

        it "redirects to projects url" do
          expect(response).to redirect_to projects_path
        end

        it "deletes the requested record " do
          expect(Project.all).to be_empty
        end

        it "displays proper flush message" do
          expect(flash[:notice]).to include("Poject was successfully destroyed.")
        end
      end

      context "when signed in as contributor" do
        let(:signed_user) { contributor }

        it "returns forbidden status" do
          expect(response).to have_http_status(:forbidden)
        end
      end

      context "when signed in as non-participant" do
        let(:signed_user) { non_participant }

        it "returns forbidden status" do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    describe "GET #link_contributors" do
      context "when logged as manager" do
        before { get :link_contributors, params: { id: project.id } }

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "renders template index" do
          expect(response).to render_template(:link_contributors)
        end
      end

      context "when logged as contributor" do
        before {
          sign_in(contributor)
          get :link_contributors, params: { id: project.id }
        }

        it "returns http success" do
          expect(response).to have_http_status(:forbidden)
        end

        it "renders template index" do
          expect(response).not_to render_template(:link_contributors)
        end
      end

      context "when logged as non-participant" do
        before {
          sign_in(non_participant)
          get :link_contributors, params: { id: project.id }
        }

        it "returns http success" do
          expect(response).to have_http_status(:forbidden)
        end

        it "renders template index" do
          expect(response).not_to render_template(:link_contributors)
        end
      end
    end
  end
end
