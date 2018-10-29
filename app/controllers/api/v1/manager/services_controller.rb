class Api::V1::Manager::ServicesController < Api::V1::Manager::ApplicationController
  include Api::V1::Manager::ServicesControllerDoc

  before_action :apipie_validations

  def index
    services = Service.order(:name).page(params[:page]).per(params[:per_page])
    serialized_services = serialize_collection(services, Api::V1::Manager::ServiceSerializer)

    total = services.count

    render_data(services: serialized_services, total: total)
  end

  def create
    service = Service.new(service_params)

    if service.save(service_params)
      render_data(id: service.id)
    else
      unprocessable_entity(service.errors.messages)
    end
  end

  def update
    service = Service.find(params[:id])

    if service.update(service_params)
      render_success
    else
      unprocessable_entity(service.errors.messages)
    end
  end

  def destroy
    service = Service.find(params[:id])
    service.destroy

    render_success
  end

  private

  def service_params
    params.require(:service).permit(:name, :cost)
  end
end
