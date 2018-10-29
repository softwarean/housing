class Web::Admin::ServicesController < Web::Admin::ApplicationController
  def index
    @q = Service.order(:name).ransack(params[:q])
    @services = @q.result.page(params[:page])
  end

  def new
    @service = Service.new
  end

  def edit
    @service = Service.find(params[:id])
  end

  def create
    @service = Service.new(service_params)

    if @service.save
      redirect_to(admin_services_path)
    else
      render(:new)
    end
  end

  def update
    @service = Service.find(params[:id])

    if @service.update(service_params)
      redirect_to(admin_services_path)
    else
      render(:edit)
    end
  end

  def destroy
    @service = Service.find(params[:id])
    @service.destroy

    redirect_to admin_services_path
  end

  private

  def service_params
    params.require(:service).permit(:name, :cost)
  end
end
