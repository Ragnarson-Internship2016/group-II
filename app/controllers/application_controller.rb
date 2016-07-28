class ApplicationController < ActionController::Base
  include Pundit
  before_action :fetch_unread_notification_count
  protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :render_forbidden
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def render_forbidden
    render status: :forbidden, plain: "403 Forbidden"
  end

  def record_not_found
    respond_to do |format|
      format.html { redirect_to root_path, notice: "Error, wrong params in the request - record could not be found" }
      format.json { head :not_found }
    end
  end

  private

  def fetch_unread_notification_count
    @notification_no = current_user.incoming_notifications.not_read.size
  end
end
