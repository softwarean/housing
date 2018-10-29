module PunditConcern
  extend ActiveSupport::Concern
  include Pundit

  def authorize_admin
    authorize :admin
  end

  def authorize_user
    authorize :user
  end

  def authorize_manager
    authorize :manager
  end
end
