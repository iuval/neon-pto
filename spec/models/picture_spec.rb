require 'spec_helper'

describe Picture do
  before(:each) do
    @picture = FactoryGirl.build(:picture)
  end

  it 'should create a new instance given a valid attribute' do
    @picture.should be_valid
  end

  it 'should require a file' do
    @picture.remove_file!
    @picture.should_not be_valid
  end

  it 'should require a user' do
    @picture.user = nil
    @picture.should_not be_valid
  end


end
