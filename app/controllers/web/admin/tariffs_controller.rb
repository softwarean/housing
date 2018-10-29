class Web::Admin::TariffsController < Web::Admin::ApplicationController
  def index
    @q = Tariff.order(:name).ransack(params[:q])
    @tariffs = @q.result.page(params[:page])
  end

  def new
    @tariff = Tariff.new
  end

  def edit
    @tariff = Tariff.find(params[:id])
  end

  def create
    @tariff = Tariff.new(tariff_params)

    if @tariff.save
      redirect_to(admin_tariffs_path)
    else
      render(:new)
    end
  end

  def update
    @tariff = Tariff.find(params[:id])

    if @tariff.update(tariff_params)
      redirect_to(admin_tariffs_path)
    else
      render(:edit)
    end
  end

  def destroy
    @tariff = Tariff.find(params[:id])
    @tariff.destroy

    redirect_to admin_tariffs_path
  end

  private

  def tariff_params
    params.require(:tariff).permit(:name, :kind, :unit_of_measure, :value)
  end
end
