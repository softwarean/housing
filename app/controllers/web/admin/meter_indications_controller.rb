class Web::Admin::MeterIndicationsController < Web::Admin::ApplicationController
  def index
    @q = MeterIndication.web.ransack(params[:q])
    @meter_indications = @q.result.page(params[:page])
  end
end
