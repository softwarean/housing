class Web::ApplicationController < ApplicationController
  include AuthHelper
  include PunditConcern

  protect_from_forgery

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(_exception)
    flash[:error] = t 'pundit.not_authorized'
    redirect_to login_path
  end
end
