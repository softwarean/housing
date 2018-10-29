module Web::Admin::ApartmentsHelper
  def houses_collection
    collection = []

    House.includes(:street).each do |house|
      collection.push(["#{house.street.name}, #{house.house_number}", house.id])
    end

    collection
  end
end
