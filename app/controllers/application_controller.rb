class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  private

  def render_error(message, status)
    respond_to do |format|
      format.any { render json: { message: message }, status: status }
    end
  end
end
