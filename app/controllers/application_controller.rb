class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :render_forbidden
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def raise_not_found
    raise ActionController::RoutingError.new("Not Found")
  end

  def render_forbidden
    render status: :forbidden, plain: "403 Forbidden"
  end

  def record_not_found
    respond_to do |format|
      format.html { redirect_to root_path, notice: "Error, wrong params in the request - record could not be found" }
      format.json { head :not_found }
    end
  end
end
