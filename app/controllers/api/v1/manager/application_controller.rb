class Api::V1::Manager::ApplicationController < Api::V1::ApplicationController
  before_action :authorize_manager
  after_action :verify_authorized
end
