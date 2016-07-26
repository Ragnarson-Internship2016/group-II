class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action { authorize @project, :access? }
  before_action only: [:update, :destroy] { authorize @event, :modify? }

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

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_event
    @event = @project.events.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :date)
  end
end
