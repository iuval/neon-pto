require 'spec_helper'

describe Report do
  describe 'validation' do
    before(:each) do
      @report = FactoryGirl.create(:report)
    end

    it 'should create a new instance given a valid attribute' do
      expect(@report).to be_valid
    end

    it 'should require a user' do
      @report.user = nil
      expect(@report).not_to be_valid
    end

    it 'should require a title' do
      @report.title = ''
      expect(@report).not_to be_valid
    end

    it 'should require a body' do
      @report.body = ''
      expect(@report).not_to be_valid
    end

    it 'should reject body too long' do
      @report.body = 'a' * (Report.max_chars + 1)
      expect(@report).not_to be_valid
    end

    it 'should require a date' do
      @report.date = nil
      expect(@report).not_to be_valid
    end
  end

  describe 'scopes' do
    before(:each) do
      @published = FactoryGirl.create_list(:report_published, 5)
      @unpublished = FactoryGirl.create_list(:report_unpublished, 5)
    end

    it 'should return only published reports' do
      Report.published =~ @published
    end

    it 'should not return unpublished reports' do
      Report.published =~ @published
    end
  end

end
