class Api::V1::User::TariffsController < Api::V1::User::ApplicationController
  include Api::V1::User::TariffsControllerDoc

  before_action :apipie_validations, only: [:index]

  def index
    tariffs = Tariff.order(:name).page(params[:page]).per(params[:per_page])
    serialized_tariffs = serialize_collection(tariffs, Api::V1::User::TariffSerializer)

    total = Tariff.count

    render_data(tariffs: serialized_tariffs, total: total)
  end
end
