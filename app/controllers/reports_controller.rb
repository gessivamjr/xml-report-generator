class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @reports = Report.where(user_id: current_user.id).order(:created_at)
  end

  def new
  end

  def create
    report = Report.new(title: params[:title], user_id: current_user.id)
    file = params[:report_files]

    if file.nil?
      flash[:alert] = 'Relatório deve conter no mínimo um arquivo .xml'
      return redirect_to action: 'new'
    end

    filename = file.original_filename
    file_type = filename.slice(-4..-1)

    if file_type != '.xml' && file_type != '.zip'
      flash[:alert] = 'Arquivo deve ser .xml ou .zip que contenha arquivos .xml'
      return redirect_to action: 'new'
    end

    tmp_file_path = Rails.root.join('public', 'uploads', filename)
    File.open(tmp_file_path, 'wb') do |f|
      f.write(file.read)
    end

    if !report.save
      flash[:alert] = report.errors.full_messages.join(', ')
      return redirect_to action: 'new'
    end

    ProcessReportFilesJob.perform_now(report, tmp_file_path.to_s, zip_file: filename.ends_with?('.zip'))
    flash[:notice] = 'Relatório criado com sucesso. Aguarde o processamento ser finalizado para acessá-lo.'
    redirect_to action: 'index'
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
