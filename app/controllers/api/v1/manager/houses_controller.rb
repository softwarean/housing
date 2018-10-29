class Api::V1::Manager::HousesController < Api::V1::Manager::ApplicationController
  include Api::V1::Manager::HousesControllerDoc

  before_action :apipie_validations

  def index
    q = House.ransack(query).result

    houses = q.page(params[:page]).per(params[:per_page])
    serialized_houses = serialize_collection(houses, Api::V1::Manager::HouseSerializer)

    total = q.count

    render_data(houses: serialized_houses, total: total)
  end

  def count
    houses_count = House.count

    render_data(count: houses_count)
  end

  private

  def query
    permitted_query = params.permit(q: [:street_id_eq])
    permitted_query[:q]
  end
end
