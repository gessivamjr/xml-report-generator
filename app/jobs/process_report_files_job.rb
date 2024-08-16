require 'zip'

class ProcessReportFilesJob < ApplicationJob
  queue_as :default

  def perform(report, path_string, zip_file: false)
    file_path = Pathname.new(path_string)

    if zip_file
      Zip::File.open(file_path) do |zip_file|
        zip_file.each_entry do |entry|
          next unless entry.name.end_with?('.xml')
          file_stream = entry.get_input_stream
          xml_content = file_stream.read
          process_xml(report, Hash.from_xml(xml_content))
        end
      end
    else
      xml_content = File.read(file_path)
      process_xml(report, Hash.from_xml(xml_content))
    end

    File.delete(file_path)
    report.status_avaiable! if !report.status_failed?
  end

  def process_xml(report, hash)
    invoice_info = hash.dig('NFe', 'infNFe')
    if invoice_info.nil?
      report.status = 'failed'
      report.failure_reason = 'Informação da Nota Fiscal está indisponível'
      return report.save
    end

    invoice =
      ProcessReportFilesHelper.create_invoice(report.id, invoice_info['ide'],
                                              invoice_info.dig('total', 'ICMSTot'))

    if invoice[:errors].present?
      invoice_number = invoice_info.dig('ide', 'nNF')
      failure_reason = "Processamento da nota fiscal #{invoice_number || ''} " \
                       "apresentou um erro inesperado. #{invoice[:errors]}"
      failure_reason.strip.squeeze!(' ')
      report.status = 'failed'
      report.failure_reason = failure_reason
      return report.save
    end

    ProcessReportFilesHelper.create_issuer(invoice.id, invoice_info['emit'])
    ProcessReportFilesHelper.create_recipient(invoice.id, invoice_info['dest'])
    ProcessReportFilesHelper.create_products(invoice.id, invoice_info['det'])
  end
end

