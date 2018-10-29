class Api::V1::Manager::StreetsController < Api::V1::Manager::ApplicationController
  include Api::V1::Manager::StreetsControllerDoc

  before_action :apipie_validations

  def index
    streets = Street.order(:name).page(params[:page]).per(params[:per_page])
    serialized_streets = serialize_collection(streets, Api::V1::Manager::StreetSerializer)

    total = Street.count

    render_data(streets: serialized_streets, total: total)
  end
end
