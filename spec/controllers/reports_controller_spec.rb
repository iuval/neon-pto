require 'spec_helper'

describe ReportsController do
  login

  describe "GET index" do
    it "assigns this months reports as @reports" do
      report = FactoryGirl.create(:report, :published)
      get :index, {}
      assigns(:reports).should eq([report])
    end

    it "assigns only this months reports as @reports" do
      report = FactoryGirl.create(:report, :published)
      Timecop.freeze(Date.today - 1.month) do
        last_month_report = FactoryGirl.create(:report, :published)
      end

      get :index, {}
      assigns(:reports).should eq([report])
    end

    it "assigns only published reports as @reports" do
      report = FactoryGirl.create(:report, :published)
      unpublished_report = FactoryGirl.create(:report, :unpublished)

      get :index, {}
      assigns(:reports).should eq([report])
    end
  end

  describe "GET show" do
    it "assigns the requested report as @report" do
      report = FactoryGirl.create(:report)
      get :show, {id: report.to_param}
      assigns(:report).should eq(report)
    end
  end

  describe "GET new" do
    it "assigns a new report as @report" do
      get :new, {}
      assigns(:report).should be_a_new(Report)
    end
  end

  describe "GET edit" do
    it "assigns the requested report as @report" do
      report = FactoryGirl.create(:report, user: subject.current_user)
      get :edit
      assigns(:report).should eq(report)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Report" do
        expect {
          post :create, {report: FactoryGirl.build(:report).attributes}
        }.to change(Report, :count).by(1)
      end

      it "assigns a newly created report as @report" do
        post :create, {report: FactoryGirl.build(:report).attributes}
        assigns(:report).should be_a(Report)
        assigns(:report).should be_persisted
      end

      it "redirects to the created report" do
        post :create, {report: FactoryGirl.build(:report).attributes}
        response.should redirect_to(Report.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved report as @report" do
        # Trigger the behavior that occurs when invalid params are submitted
        Report.any_instance.stub(:save).and_return(false)
        post :create, {report: { "user" => "invalid value" }}
        assigns(:report).should be_a_new(Report)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Report.any_instance.stub(:save).and_return(false)
        post :create, {report: { "user" => "invalid value" }}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested report" do
        report = FactoryGirl.create(:report, user: subject.current_user)
        Report.any_instance.should_receive(:update).with({ "user" => nil })
        put :update, {id: report.to_param, report: { "user" => nil }}
      end

      it "assigns the requested report as @report" do
        report = FactoryGirl.create(:report, user: subject.current_user)
        put :update, {id: report.to_param, report: FactoryGirl.build(:report).attributes}
        assigns(:report).should eq(report)
      end

      it "redirects to the report" do
        report = FactoryGirl.create(:report, user: subject.current_user)
        put :update, {id: report.to_param, report: FactoryGirl.build(:report).attributes}
        response.should redirect_to(report)
      end

      it "redirects to the reports if current user is not author of report" do
        report = FactoryGirl.create(:report)
        put :update, {id: report.to_param, report: FactoryGirl.build(:report).attributes}
        response.should redirect_to(reports_path)
      end
    end

    describe "with invalid params" do
      it "assigns the report as @report" do
        report = FactoryGirl.create(:report, user: subject.current_user)
        # Trigger the behavior that occurs when invalid params are submitted
        Report.any_instance.stub(:save).and_return(false)
        put :update, {id: report.to_param, report: { "user" => "invalid value" }}
        assigns(:report).should eq(report)
      end

      it "re-renders the 'edit' template" do
        report = FactoryGirl.create(:report, user: subject.current_user)
        # Trigger the behavior that occurs when invalid params are submitted
        Report.any_instance.stub(:save).and_return(false)
        put :update, {id: report.to_param, report: { "user" => "invalid value" }}
        response.should render_template("edit")
      end
    end
  end
end
