class Api::V1::Manager::MetersController < Api::V1::Manager::ApplicationController
  include Api::V1::Manager::MetersControllerDoc
  include SegmentsConcern

  before_action :apipie_validations

  def houses_data
    data = Api::Manager::ReportsService.houses_data(period_from_segment, street_query)

    render_data(data)
  end

  def apartments_data
    data = Api::Manager::ReportsService.apartments_data(params[:house_id], period_from_segment)

    render_data(data)
  end

  def apartment_details
    account_info = account_data

    meters = Meter.for_account(account_info[:account_number])
    diffs_with_tariffs = Api::ReportsService.diffs_with_tariffs(meters, period_from_segment)

    render_data(account_info: account_info, diffs_data: diffs_with_tariffs)
  end

  def apartment_details_by_service
    account_info = account_data

    service = params[:service]
    meters_kind = "#{service}_meter"

    meters = Meter.for_account(account_info[:account_number]).where(kind: meters_kind)
    diffs_with_tariffs = Api::ReportsService.diffs_with_tariffs(meters, period_from_segment)

  end

  private

  def account_data
    apartment = Apartment.find(params[:apartment_id])
    house = apartment.house
    street = house.street

    address = I18n.t('address', street: street.name, house: house.house_number, apartment: apartment.number)
    account_number = apartment.account.account_number

    {
      address: address,
      account_number: account_number
    }
  end

  def street_query
    { name_cont: params[:street_name_cont] }
  end
end
