class ApplicationController < ActionController::Base


  protect_from_forgery with: :null_session, if: -> { request.format.json? }

  wrap_parameters false

  rescue_from ActiveRecord::RecordNotFound do |_exception|
    render status: :not_found #404
  end
end
