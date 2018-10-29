class Web::Admin::HousesController < Web::Admin::ApplicationController
  def index
    @q = House.includes(:street).order(:house_number).ransack(params[:q])
    @houses = @q.result.page(params[:page])
  end

  def new
    @house = House.new
  end

  def edit
    @house = House.find(params[:id])
  end

  def create
    @house = House.new(house_params)

    if @house.save
      redirect_to(admin_houses_path)
    else
      render(:new)
    end
  end

  def update
    @house = House.find(params[:id])

    if @house.update(house_params)
      redirect_to(admin_houses_path)
    else
      render(:edit)
    end
  end

  def destroy
    @house = House.find(params[:id])

    flash[:error] = @house.errors.full_messages unless @house.destroy

    redirect_to admin_houses_path
  end

  private

  def house_params
    params.require(:house).permit(:street_id, :house_number)
  end
end
