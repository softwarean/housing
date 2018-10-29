class Web::Admin::WelcomeController < Web::Admin::ApplicationController
  def index
    redirect_to admin_users_path
  end
end
