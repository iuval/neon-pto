include Warden::Test::Helpers

module RequestHelpers
  def create_logged_in_admin
    login(FactoryGirl.create(:admin))
  end

  def create_logged_in_member
    login(FactoryGirl.create(:member))
  end

  def login(user)
    login_as user, scope: :user
    user
  end
end
