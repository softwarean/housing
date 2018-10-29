module DefaultCrudManagerAuthorizationTest
  extend ActiveSupport::Concern

  included do
    test 'should not have access to actions unless role is manager' do
      not_managers.each do |u|
        token = auth_token(u)
        include_auth_header(token)

        assert_default_actions_responce(:unauthorized)
      end
    end
  end
end
