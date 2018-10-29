class Web::SessionsController < Web::ApplicationController
  layout 'session'

  def new
    @session = WebSignInType.new
  end

  def create
    @session = WebSignInType.new(web_sign_in_type_params)
    user = @session.user

    if user.blank?
      @session.errors[:email] << t('user_not_found')
      render :new
    elsif @session.valid?
      sign_in(user)
      redirect_by_role(user)
    else
      @session.errors[:email] << t('authentication_error')
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to login_path
  end

  private

  def web_sign_in_type_params
    params.require(:web_sign_in_type).permit(:email, :password)
  end

  def redirect_by_role(user)
    path = if user.role.admin?
      admin_root_path
    else
      root_path
    end

    redirect_to path
  end
end
