class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :render_forbidden

  def raise_not_found
    raise ActionController::RoutingError.new("Not Found")
  end

  def render_forbidden
    render status: :forbidden, plain: "403 Forbidden"
  end
end
