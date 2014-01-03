require 'spec_helper'

describe User do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  it 'should create a new instance given a valid attribute' do
    @user.should be_valid
  end

  it 'should require an email address' do
    @user.email = ''
    @user.should_not be_valid
  end

  it 'should reject a non neonroots email' do
    @user.email = 'other@notvalid.com'
    @user.should_not be_valid
  end

  it 'should reject duplicate email addresses' do
    user_with_duplicate_email = FactoryGirl.build(:user, email: @user.email)
    user_with_duplicate_email.should_not be_valid
  end
end
