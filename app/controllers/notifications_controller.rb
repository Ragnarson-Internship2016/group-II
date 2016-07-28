class NotificationsController < ApplicationController

  def index
    @notifications = current_user.incoming_notifications.not_read
  end

  def mark_as_read
    @notification = Notification.find(params[:id])
    if @notification.update_attribute(:read, true)
      redirect_to notifications_path
    else
      redirect_to root_path, notice: "Unable to update notification"
    end
  end
end
