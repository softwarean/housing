class Web::Admin::ApartmentsController < Web::Admin::ApplicationController
  def index
    @q = Apartment.includes(house: :street).order_by_address.ransack(params[:q])
    @apartments = @q.result.page(params[:page])
  end

  def new
    @creation_type = ApartmentsCreationType.new
  end

  def create
    @creation_type = ApartmentsCreationType.new(apartment_params)

    if @creation_type.valid?
      @creation_type.create_apartments
      redirect_to(admin_apartments_path)
    else
      render(:new)
    end
  end

  def destroy
    @apartment = Apartment.find(params[:id])
    @errors = @apartment.errors.full_messages unless @apartment.destroy

    respond_to do |format|
      format.html { redirect_to admin_apartments_path, alert: @errors }
      format.js
    end
  end

  private

  def apartment_params
    params.require(:apartments_creation_type).permit(:house_id, :number_of_apartments)
  end
end
