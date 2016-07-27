require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let!(:project) { FactoryGirl.create(:project) }
  let!(:project_contributor) do
    project.contributors.create(FactoryGirl.attributes_for(:user))
  end
  let!(:events) do
    3.times.collect { FactoryGirl.create(:event, project: project) }
  end
  let!(:another_project) { FactoryGirl.create(:project) }
  let!(:another_events) do
    3.times.collect { FactoryGirl.create(:event, project: another_project) }
  end
  let!(:another_user) { FactoryGirl.create(:user) }
  let(:project_user) do
    project.contributors.create(FactoryGirl.attributes_for(:user))
  end
  let(:valid_attributes) { FactoryGirl.attributes_for(:event) }
  let(:invalid_attributes) { FactoryGirl.attributes_for(:event, date: nil) }
  before { sign_in(project_contributor) }

  describe "GET #index" do
    context "when project exists" do
      context "when user is signed in" do
        context "when user is project manager" do
          before { sign_in(project.user) }

          it "renders index template" do
            get :index, params: {project_id: project.id}
            expect(response).to render_template(:index)
          end
        end

        context "when user is project contributor" do

          it "renders index template" do
            get :index, params: {project_id: project.id}
            expect(response).to render_template(:index)
          end
        end

        context "when user does not take part in project" do
          before { sign_in(another_user) }

          it "returns forbidden status" do
            get :index, params: {project_id: project.id}
            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      context "when user is not signed in" do
        before { sign_out(project_contributor) }

        it "redirects to sign in page" do
          get :index, params: {project_id: project.id}
          expect(response).to redirect_to(new_user_session_url)
        end
      end
    end

    context "when project does not exists" do
      it "redirects to root" do
        expect(get :index, params: {project_id: -1}).to redirect_to(root_url)
      end
    end
  end

  describe "GET #show" do
    let(:event) { events.first }

    context "when event exists" do
      before { get :show, params: {project_id: event.project_id, id: event.id} }

      it "assigns the requested event as @event" do
        expect(assigns(:event)).to eq(event)
      end

      it "renders show template" do
        expect(response).to render_template(:show)
      end
    end

    context "when event does not exist" do
      it "redirects to root" do
        expect(get :show, params: {project_id: project.id, id: -1}).
          to redirect_to(root_url)
      end
    end

    context "when event does not belong to given project" do
      it "redirects to root" do
        expect(get :show, params: {
          project_id: another_project.id, id: event.id
        }).to redirect_to(root_url)
      end
    end
  end

  describe "GET #new" do
    before { get :new, params: {project_id: project.id} }

    it "assigns a new event as @event" do
      expect(assigns(:event)).to be_a_new(Event)
    end

    it "assigns event with correct project_id" do
      expect(assigns(:event).project_id).to eql(project.id)
    end

    it "renders new template" do
      expect(response).to render_template(:new)
    end
  end

  describe "GET #edit" do
    let(:event) { events.first }
    before { get :edit, params: {project_id: project.id, id: event.id} }

    it "assigns the requested event as @event" do
      expect(assigns(:event)).to eq(event)
    end

    it "renders edit template" do
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Event" do
        expect {
          post :create, params: {
            project_id: project.id, event: valid_attributes
          }
        }.to change(Event, :count).by(1)
      end

      it "assigns a newly created event as @event" do
        post :create, params: {project_id: project.id, event: valid_attributes}
        expect(assigns(:event)).to be_a(Event)
        expect(assigns(:event)).to be_persisted
      end

      it "redirects to the created event" do
        post :create, params: {project_id: project.id, event: valid_attributes}
        expect(response).to redirect_to([project, Event.last])
      end
    end

    context "with invalid params" do
      before do
        post :create, params: {project_id: project.id, event: invalid_attributes}
      end

      it "assigns a newly created but unsaved event as @event" do
        expect(assigns(:event)).to be_a_new(Event)
      end

      it "re-renders the 'new' template" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PUT #update" do
    let(:event) { Event.first }
    let(:new_attributes) { FactoryGirl.attributes_for(:event) }

    context "when signed in as an author" do
      before { sign_in(event.author) }

      context "with valid params" do
        before do
          put :update, params: {
            project_id: project.id, id: event.id, event: new_attributes
          }
        end

        it "updates the requested event" do
          event.reload
          expect(event.title).to eql(new_attributes[:title])
          expect(event.description).to eql(new_attributes[:description])
          expect(event.date).to eql(new_attributes[:date])
        end

        it "assigns the requested event as @event" do
          expect(assigns(:event)).to eq(event)
        end

        it "redirects to the event" do
          expect(response).to redirect_to([event.project, event])
        end
      end

      context "with invalid params" do
        before do
          put :update, params: {
            project_id: project.id, id: event.id, event: invalid_attributes
          }
        end

        it "assigns the event as @event" do
          expect(assigns(:event)).to eq(event)
        end

        it "re-renders the 'edit' template" do
          expect(response).to render_template(:edit)
        end
      end
    end

    context "when signed in as non-author user" do
      before { sign_in(project_user) }

      it "returns forbidden status" do
        put :update, params: {
          project_id: project.id, id: event.id, event: new_attributes
        }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "DELETE #destroy" do
    let(:event) { Event.first }

    context "when signed in as an author event" do
      before { sign_in(event.author) }

      it "destroys the requested event" do
        expect {
          delete :destroy, params: {project_id: event.project_id, id: event.id}
        }.to change(Event, :count).by(-1)
      end

      it "redirects to the events list" do
        delete :destroy, params: {project_id: event.project_id, id: event.id}
        expect(response).to redirect_to(project_events_url(event.project))
      end
    end

    context "when signed in as non-author user" do
      before { sign_in(project_user) }

      it "returns forbidden status" do
        delete :destroy, params: {project_id: event.project_id, id: event.id}
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
