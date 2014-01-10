require 'spec_helper'

describe User do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  it 'should create a new instance given a valid attribute' do
    expect(@user).to be_valid
  end

  it 'should require an email address' do
    @user.email = ''
    expect(@user).not_to be_valid
  end

  it 'should reject a non neonroots email' do
    @user.email = 'other@notvalid.com'
    expect(@user).not_to be_valid
  end

  it 'should reject duplicate email addresses' do
    user_with_duplicate_email = FactoryGirl.build(:user, email: @user.email)
    expect(user_with_duplicate_email).not_to be_valid
  end
end
