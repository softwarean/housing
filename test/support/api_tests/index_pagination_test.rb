module IndexPaginationTest
  extend ActiveSupport::Concern

  included do
    test 'should not get index if page param is missing' do
      get :index, params: { per_page: 25 }

      assert_response :unprocessable_entity
    end

    test 'should not get index if per_page param is missing' do
      get :index, params: { page: 1 }

      assert_response :unprocessable_entity
    end
  end
end
