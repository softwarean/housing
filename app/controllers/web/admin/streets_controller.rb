class Web::Admin::StreetsController < Web::Admin::ApplicationController
  def index
    @q = Street.order(:name).ransack(params[:q])
    @streets = @q.result.page(params[:page])
  end

  def new
    @street = Street.new
  end

  def edit
    @street = Street.find(params[:id])
  end

  def create
    @street = Street.new(street_params)

    if @street.save
      redirect_to(admin_streets_path)
    else
      render(:new)
    end
  end

  def update
    @street = Street.find(params[:id])

    if @street.update(street_params)
      redirect_to(admin_streets_path)
    else
      render(:edit)
    end
  end

  def destroy
    @street = Street.find(params[:id])

    flash[:error] = @street.errors.full_messages unless @street.destroy

    redirect_to admin_streets_path
  end

  private

  def street_params
    params.require(:street).permit(:name)
  end
end
