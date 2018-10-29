module Web::Admin::AccountsHelper
  def apartments_collection
    collection = []

    Apartment.includes(house: :street).order_by_address.each do |apartment|
      collection.push(["#{apartment.house.street.name}, #{apartment.house.house_number}, #{apartment.number}", apartment.id])
    end

    collection
  end
end
