class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @reports = Report.where(user_id: current_user.id).order(:created_at)
  end

  def new
  end

  def create
  end

  def show
    @report = Report.find(params[:id])
    @invoices = @report.invoices
  end

  def update
    report = Report.find(id: params[:id])
  end

  def destroy
    report = Report.find(id: params[:id])
  end

  def export_csv
    report = Report.find(id: params[:id])
  end
end
