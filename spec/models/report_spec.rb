require 'spec_helper'

describe Report do
  before(:each) do
    @report = FactoryGirl.create(:report)
  end

  it 'should create a new instance given a valid attribute' do
    @report.should be_valid
  end

  it 'should require a user' do
    @report.user = nil
    @report.should_not be_valid
  end

  it 'should require a title' do
    @report.title = ''
    @report.should_not be_valid
  end

  it 'should require a body' do
    @report.body = ''
    @report.should_not be_valid
  end

  it 'should reject body too long' do
    @report.body = 'a' * (Report.max_chars + 1)
    @report.should_not be_valid
  end

  it 'should require a date' do
    @report.date = nil
    @report.should_not be_valid
  end

end
