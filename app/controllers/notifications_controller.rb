class NotificationsController < ApplicationController

  def index
    @notifications = current_user.incoming_notifications
  end

end
