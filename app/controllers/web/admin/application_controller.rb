class Web::Admin::ApplicationController < Web::ApplicationController
  before_action :authorize_admin
  after_action :verify_authorized
end
