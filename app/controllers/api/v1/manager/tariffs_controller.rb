class Api::V1::Manager::TariffsController < Api::V1::Manager::ApplicationController
  include Api::V1::Manager::TariffsControllerDoc

  before_action :apipie_validations

  def index
    tariff = Tariff.order(:name).page(params[:page]).per(params[:per_page])
    serialized_tariff = serialize_collection(tariff, Api::V1::Manager::TariffSerializer)

    total = Tariff.count

    render_data(tariffs: serialized_tariff, total: total)
  end

  def kinds
    kinds = Tariff.kind.options

    render_data(kinds: kinds)
  end

  def create
    tariff = Tariff.new(tariff_params)

    if tariff.save
      render_data(id: tariff.id)
    else
      unprocessable_entity(tariff.errors.messages)
    end
  end

  def update
    tariff = Tariff.find(params[:id])

    if tariff.update(tariff_params)
      render_success
    else
      unprocessable_entity(tariff.errors.messages)
    end
  end

  def destroy
    tariff = Tariff.find(params[:id])
    tariff.destroy

    render_success
  end

  private

  def tariff_params
    params.require(:tariff).permit(:name, :kind, :unit_of_measure, :value)
  end
end
