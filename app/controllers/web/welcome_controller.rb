class Web::WelcomeController < Web::ApplicationController
  def index
    if current_user&.role&.admin?
      redirect_to admin_root_path
      return
    end

    if Rails.env.in? ['development', 'test']
      head :ok, content_type: 'text/html'
    else
      render file: 'public/index.html', status: :ok, layout: false
    end
  end
end
