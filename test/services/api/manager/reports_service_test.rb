require 'test_helper'

class Api::Manager::ReportsServiceTest < ActiveSupport::TestCase
  NUMBER_OF_CLAIMS = 3

  setup do
    @account = create :account
    @user = create :user, accounts: [@account]
    @house = create :house
    @apartment = create :apartment, house: @house, account: @account

    @today = DateTime.current
    @day_range = @today.beginning_of_day..@today.end_of_day
    @month_range = @today.beginning_of_month..@today.end_of_month
    @year_range = @today.beginning_of_year..@today.end_of_year
  end

  test 'house claims count for year' do
    create_claims('year')

    claims_count = Api::Manager::ReportsService.house_claims_count(@house, @year_range)
    assert_equal(claims_count, 1)
  end

  test 'house claims count for month' do
    create_claims('month')

    claims_count = Api::Manager::ReportsService.house_claims_count(@house, @month_range)
    assert_equal(claims_count, 1)
  end

  test 'house claims count for day' do
    create_claims('day')

    claims_count = Api::Manager::ReportsService.house_claims_count(@house, @day_range)
    assert_equal(claims_count, 1)
  end

  test 'apartment claims count for year' do
    create_claims('year')

    claims_count = Api::Manager::ReportsService.apartment_claims_count(@apartment, @year_range)
    assert_equal(claims_count, 1)
  end

  test 'apartment claims count for month' do
    create_claims('month')

    claims_count = Api::Manager::ReportsService.apartment_claims_count(@apartment, @month_range)
    assert_equal(claims_count, 1)
  end

  test 'apartment claims count for day' do
    create_claims('day')

    claims_count = Api::Manager::ReportsService.apartment_claims_count(@apartment, @day_range)
    assert_equal(claims_count, 1)
  end

  private

  def create_claims(step)
    NUMBER_OF_CLAIMS.times do |i|
      create :claim, user_id: @user.id, created_at: DateTime.current + i.send(step)
    end
  end
end
