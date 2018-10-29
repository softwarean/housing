class Api::V1::User::ServicesController < Api::V1::User::ApplicationController
  include Api::V1::User::ServicesControllerDoc

  before_action :apipie_validations, only: [:index]

  def index
    services = Service.order(:name).page(params[:page]).per(params[:per_page])
    serialized_services = serialize_collection(services, Api::V1::User::ServiceSerializer)

    total = Service.count

    render_data(services: serialized_services, total: total)
  end
end
