module DefaultCrudTokenNecessityTest
  extend ActiveSupport::Concern

  included do
    test 'should require token for default actions' do
      include_auth_header('invalid_token')

      assert_default_actions_responce(:forbidden)
    end
  end
end
