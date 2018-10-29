class Api::V1::Manager::ApartmentsController < Api::V1::Manager::ApplicationController
  include Api::V1::Manager::ApartmentsControllerDoc

  before_action :apipie_validations

  def index
    q = Apartment.ransack(query).result

    apartments = q.page(params[:page]).per(params[:per_page])
    serialized_apartments = serialize_collection(apartments, Api::V1::Manager::ApartmentSerializer)

    total = q.count

    render_data(apartments: serialized_apartments, total: total)
  end

  def count
    apartments_count = Apartment.count

    render_data(count: apartments_count)
  end

  private

  def query
    permitted_query = params.permit(q: [:house_id_eq])
    permitted_query[:q]
  end
end
