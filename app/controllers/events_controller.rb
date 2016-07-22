class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authorize_project_access
  before_action :authorize_event_modify, only: [:update, :destroy]

  def index
    @events = @project.events
  end

  def show
  end

  def new
    @event = @project.events.new
  end

  def edit
  end

  def create
    @event = @project.events.new(event_params)
    @event.author = current_user
    if @event.save
      redirect_to(
        [@event.project, @event],
        notice: "Event was successfully created."
      )
    else
      render :new
    end
  end

  def update
    if @event.update(event_params)
      redirect_to(
        [@event.project, @event],
        notice: "Event was successfully updated."
      )
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to(
      project_events_path(@event.project),
      notice: "Event was successfully destroyed."
    )
  end

  private

  def set_event
    @event = Event.find_by_id(params[:id]) || raise_not_found
  end

  def set_project
    @project = Project.find_by_id(params[:project_id]) || raise_not_found
  end

  def event_params
    params.require(:event).permit(:title, :description, :date)
  end

  def authorize_project_access
    authorize @project, :access?
  end

  def authorize_event_modify
    authorize @event, :modify?
  end
end
