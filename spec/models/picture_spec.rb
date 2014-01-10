require 'spec_helper'

describe Picture do
  before(:each) do
    @picture = FactoryGirl.build(:picture)
  end

  it 'should create a new instance given a valid attribute' do
    expect(@picture).to be_valid
  end

  it 'should require a file' do
    @picture.remove_file!
    expect(@picture).not_to be_valid
  end

  it 'should require a user' do
    @picture.user = nil
    expect(@picture).not_to be_valid
  end


end
