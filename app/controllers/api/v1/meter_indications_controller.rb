class Api::V1::MeterIndicationsController < Api::V1::ApplicationController
  include Api::V1::MeterIndicationsControllerDoc

  skip_before_action :authorize_request

  def create
    meter_indication = MeterIndication.new
    meter_indication.from_json(request.raw_post)

    if meter_indication.save
      render json: :ok, status: :ok
    else
      render_error(:unprocessable_entity, 'Invalid JSON')
    end
  end
end
