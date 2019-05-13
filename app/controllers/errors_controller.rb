class ErrorsController < ApplicationController

  def not_found
    render_error("Not Found", :not_found)
  end

  def internal_server_error
    render_error("Something went wrong", :internal_server_error)
  end
end
