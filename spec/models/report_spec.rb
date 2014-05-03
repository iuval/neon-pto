require 'spec_helper'

describe Report do
  describe 'validation' do
    before(:each) do
      @report = FactoryGirl.build(:report)
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
      @report.body = 'a' * (Report::MAX_CHARS + 1)
      expect(@report).not_to be_valid
    end

    it 'should require a date' do
      @report.month = nil
      expect(@report).not_to be_valid
    end
  end

  describe 'scopes' do
    before(:each) do
      @published = FactoryGirl.create_list(:report, 5, :published)
      @unpublished = FactoryGirl.create_list(:report, 5, :unpublished)
    end

    it 'should return only published reports' do
      expect(Report.published).to match_array(@published)
    end

    it 'should not return unpublished reports' do
      expect(Report.published).not_to match_array(@unpublished)
    end
  end

  describe 'love' do
    before(:each) do
      @report = FactoryGirl.create(:report)
      @user_1 = FactoryGirl.create(:user)
      @user_2 = FactoryGirl.create(:user)
    end

    it 'should return 1 love for this month' do
      # Last month
      Timecop.freeze(Date.today - 1.month) do
        @user_1.toggle_love @report
      end
      # Now
      @user_2.toggle_love @report

      expect(@report.love).to be(1)
    end

    it 'should return 0 love for this month' do
      # 2 months ago
      Timecop.freeze(Date.today - 2.month) do
        @user_1.toggle_love @report
        @user_2.toggle_love @report
      end

      expect(@report.love).to be(0)
    end

    it 'should return 2 love for this month' do
      @user_1.toggle_love @report
      @user_2.toggle_love @report

      expect(@report.love).to be(2)
    end
  end

end
