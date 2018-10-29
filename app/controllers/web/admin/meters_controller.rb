class Web::Admin::MetersController < Web::Admin::ApplicationController
  def index
    @q = Meter.ransack(params[:q])
    @meters = @q.result.page(params[:page])
  end

  def show
    @meter = Meter.find(params[:id])

    @q = MeterIndication.web.for_meter(@meter.uuid).ransack(params[:q])
    @meter_indications = @q.result.page(params[:page])
  end
end
