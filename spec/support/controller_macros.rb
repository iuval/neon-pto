module ControllerMacros
  def login
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:user)
    end
  end
end

