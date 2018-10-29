class ApartmentsCreationType < ActiveType::Object
  belongs_to :house

  attribute :house_id, :integer
  attribute :number_of_apartments, :integer

  validates :number_of_apartments, :house_id, presence: true
  validates_numericality_of :number_of_apartments, greater_than_or_equal_to: 1, only_integer: true

  def create_apartments
    apartments = (1..number_of_apartments).map { |number| { house_id: house_id, number: number } }

    Apartment.create(apartments)
  end
end
