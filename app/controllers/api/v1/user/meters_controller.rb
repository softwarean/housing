class Api::V1::User::MetersController < Api::V1::User::ApplicationController
  include Api::V1::User::MetersControllerDoc
  include SegmentsConcern

  before_action :apipie_validations, only: [:index, :show]

  def index
    meters = Meter.for_account(user_account_numbers)
    diffs_with_tariffs = Api::ReportsService.diffs_with_tariffs(meters, period_from_segment)

    render_data(diffs_data: diffs_with_tariffs)
  end

  def show
    query_kind = params[:kind]
    meters_kind = "#{query_kind}_meter"
    meters = Meter.for_account(user_account_numbers).where(kind: meters_kind)
    diffs_with_tariffs = Api::ReportsService.diffs_with_tariffs(meters, period_from_segment)
    render_data(diffs_data: diffs_with_tariffs.first)
  end

  private

  def user_account_numbers
    current_user.accounts.map(&:account_number)
  end
end
