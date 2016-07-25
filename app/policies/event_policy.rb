class EventPolicy
  def initialize(user, event)
    @user = user
    @event = event
  end

  def modify?
    @event.author == @user
  end
end
