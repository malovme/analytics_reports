require 'googleauth'
require 'google/apis/analytics_v3'
require 'google/apis/analyticsreporting_v4'

class ReportsController < ApplicationController

  API = Google::Apis::AnalyticsreportingV4

  before_action :load_metrics_and_dimensions, only: [:new, :create, :edit, :update]
  before_action :reject_empty_params, only: [:create, :update]

  def index
    @reports = Report.all
  end

  def show
    credentials = get_credentials
    if credentials.nil?
      render(:auth_required) && return
    end
    @accounts = get_accounts credentials
    if params.has_key?(:view)
      @ga_view = params[:view]
    else
      @ga_view = @accounts[0].web_properties[0].profiles[0].id
    end

    @report = Report.find(params[:id])

    service = API::AnalyticsReportingService.new
    service.authorization = credentials
    begin
      @result = service.batch_get_reports(get_report_request(@report, @ga_view))
    rescue Exception => e
      flash.now[:error] = e.message
    end
  end

  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)
    if @report.save
      flash[:success] = 'Report added'
      redirect_to root_path
    else
      render :new
    end

  end

  def edit
    @report = Report.find(params[:id])
  end

  def update
    @report = Report.find(params[:id])
    if @report.update_attributes(report_params)
      flash[:success] = 'Report updated'
      redirect_to root_path
    else
      flash[:error] = @report.errors
      render :edit
    end
  end

  def destroy
    @report = Report.find(params[:id])
    if @report.delete
      flash[:success] = 'Report deleted!'
      redirect_to root_path
    else
      flash[:error] = 'Failed to delete this report!'
      render :destroy
    end
  end

  private

  def load_metrics_and_dimensions
    @metrics = Metric.all
    @dimensions = Dimension.all
  end

  def reject_empty_params
    metrics = params[:report][:metrics].reject(&:empty?)
    if metrics.empty?
      params[:report][:metrics] = ''
    else
      params[:report][:metrics] = metrics
    end
    params[:report][:dimensions] = params[:report][:dimensions].reject(&:empty?)
  end

  def get_credentials
    if session[:credentials].nil?
      credentials = nil
    else
      credentials = Signet::OAuth2::Client.new(JSON.parse(session[:credentials]))
    end
    if credentials.nil? || credentials.expired?
      session[:redirect_path] = request.path
      return nil
    end
    credentials
  end

  def get_accounts credentials
    service = Google::Apis::AnalyticsV3::AnalyticsService.new
    service.authorization = credentials
    begin
      accounts = service.list_account_summaries.items
    rescue Exception => e
      flash.now[:error] = e.message
      return nil
    end
  end

  def report_params
    params.require(:report).permit(:name, :start_date, :end_date, :metrics => [], :dimensions => [])
  end

  def get_report_request(report, profile)
    report_request = API::ReportRequest.new
    report_request.view_id = "ga:" + profile
    date_range = API::DateRange.new
    date_range.start_date = report.start_date
    date_range.end_date = report.end_date
    report_request.date_ranges = [date_range]

    metrics = []
    report.metrics.each do |m|
      metric = API::Metric.new
      metric.expression = m
      metrics.push(metric)
    end
    report_request.metrics = metrics

    dimensions = []
    report.dimensions.each do |d|
      dimension = API::Dimension.new
      dimension.name = d
      dimensions.push(dimension)
    end
    report_request.dimensions = dimensions

    get_reports_request = API::GetReportsRequest.new
    get_reports_request.report_requests = [report_request]

    get_reports_request
  end


end
