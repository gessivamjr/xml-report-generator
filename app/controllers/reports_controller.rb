class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @reports = Report.where(user_id: current_user.id).order(:created_at)
  end

  def new
    @report = current_user.reports.new
  end

  def create
    @report = Report.new(title: params[:title], user_id: current_user.id)
    file = params[:report_files]

    if file.nil?
      return respond_to do |format|
        format.turbo_stream { redirect_to action: 'index' }
        format.html { redirect_to action: 'index', alert: 'Relatório deve conter no mínimo um arquivo .xml' }
        format.json { render json: { message: 'Relatório deve conter no mínimo um arquivo .xml' }, status: :bad_request }
      end
    end

    filename = file.original_filename
    file_type = filename.slice(-4..-1)

    if file_type != '.xml' && file_type != '.zip'
      return respond_to do |format|
        format.turbo_stream { redirect_to action: 'index' }
        format.html { redirect_to action: 'new', alert: 'Arquivo deve ser .xml ou .zip que contenha arquivos .xml' }
        format.json { render json: { message: 'Arquivo deve ser .xml ou .zip que contenha arquivos .xml' }, status: :bad_request }
      end
    end

    tmp_file_path = Rails.root.join('public', 'uploads', filename)
    File.open(tmp_file_path, 'wb') do |f|
      f.write(file.read)
    end

    if !@report.save
      return respond_to do |format|
        format.turbo_stream { redirect_to action: 'index' }
        format.html { redirect_to action: 'new', alert: report.errors.full_messages.join(', ') }
        format.json { render json: { message: report.errors.full_messages.join(', ') }, status: :unprocessable_entity }
      end
    end

    ProcessReportFilesJob.perform_later(@report, tmp_file_path.to_s,
                                        zip_file: filename.ends_with?('.zip'))
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append('reports', partial: 'report', locals: { report: @report })
      end
      format.html { redirect_to action: 'index', notice: 'Relatório criado com sucesso. Aguarde o processamento ser finalizado para acessá-lo.' }
      format.json { render json: { message: 'Relatório criado com sucesso. Aguarde o processamento ser finalizado para acessá-lo.' }, status: :created }
    end
  end

  def show
    @report = Report.find(params[:id])
    @invoices = @report.invoices.includes([:issuer, :recipient, :products])
                                .joins(:issuer, :recipient, :products)
    @filter_issuers = @invoices.map(&:issuer).map(&:name).uniq
    @filter_recipients = @invoices.map(&:recipient).map(&:name).uniq
    @filter_products = @invoices.map(&:products).flatten.map(&:name).uniq

    if params[:filters] == 'true'
      issuer = { name: params['issuers'] }
      recipient = { name: params['recipients'] }
      products = { name: params['products'] }
      filters = { issuer:, recipient:, products:, number: params['invoices'] }.filter do |key, value|
        key == :number ? value.present? : value[:name].present?
      end
      @filtered_invoices = @invoices.where(filters)
    end
  end

  def destroy
    @report = Report.find(params[:id])
    @report.destroy!

    respond_to do |format|
      format.turbo_stream { redirect_to action: 'index' }
      format.html { redirect_to action: 'index' }
      format.json { head :no_content }
    end
  end

  def export_csv
    report = Report.find(params[:id])

    if report.status != 'avaiable'
      return respond_to do |format|
        format.turbo_stream { redirect_to action: 'index' }
        format.html { redirect_to action: 'index' }
        format.json { render json: { message: 'Relatório indisponível para exportação de .csv' }, status: :unprocessable_entity }
      end
    end

    send_data(CsvGenerator::Report.call(report.id),
              filename: "relatorio-#{report.title}.csv",
              type: 'text/csv',
              disposition: 'attachment')
  end
end
