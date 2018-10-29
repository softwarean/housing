class Api::V1::User::ApplicationController < Api::V1::ApplicationController
  before_action :authorize_user
  after_action :verify_authorized
end
