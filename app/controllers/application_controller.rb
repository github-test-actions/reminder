class ApplicationController < ActionController::Base
  #before_action :authenticate_user!
  rescue_from CanCan::AccessDenied, with: :redirect_to_unauthorize_access
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  respond_to :json, :html

  private

  def render_unprocessable_entity_response(exception)
    redirect_to new_reminder_path(@reminder), alert: exception.message
  end

  def redirect_to_unauthorize_access(exception)
    redirect_to root_url, alert: exception.message
  end

  def render_not_found_response(exception)
    redirect_to root_url, alert: exception.message
  end
end
