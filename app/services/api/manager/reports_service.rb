module Api::Manager::ReportsService
  class << self
    def houses_data(period, street_query)
      streets = Street.joins(houses: :meters).includes(houses: :meters)
        .merge(Meter.common_house_meters).ransack(street_query).result

      streets.map do |street|
        houses = street.houses.map do |house|
          meters = house.meters

          diffs_by_kind = Api::ReportsService.diffs_by_meters_kind(meters, period)
          claims_count = house_claims_count(house, period)

          {
            id: house.id,
            number: house.house_number,
            diffs_data: diffs_by_kind,
            claims_count: claims_count
          }
        end

        {
          street: street.name,
          houses: houses
        }
      end
    end

    def apartments_data(house_id, period)
      house = House.find(house_id)
      street = house.street
      apartments = Apartment.order(:number).where(house: house)

      data = apartments.map do |apartment|
        account = apartment.account

        next if account.nil?

        meters = Meter.for_account(account.account_number)
        diffs_by_kind = Api::ReportsService.diffs_by_meters_kind(meters, period)
        claims_count = apartment_claims_count(apartment, period)

        {
          id: apartment.id,
          number: apartment.number,
          diffs_data: diffs_by_kind,
          claims_count: claims_count
        }
      end

      {
        house: "#{street.name}, #{house.house_number}" ,
        data: data.compact
      }
    end

    def house_claims_count(house, period)
      claims_counts_by_accounts = house.apartments.flat_map do |apartment|
        account = apartment.account

        next 0 if account.nil?

        users_claims(account, period)
      end

      sum_all(claims_counts_by_accounts)
    end

    def apartment_claims_count(apartment, period)
      sum_all users_claims(apartment.account, period)
    end

    private

    def users_claims(account, period)
      account.users.map { |user| user.claims.for_period(period).count }
    end

    def sum_all(collection)
      collection.reduce(0, &:+)
    end
  end
end
