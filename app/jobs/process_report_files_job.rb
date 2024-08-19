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

    report.status_avaiable! if !report.status_failed?
  end

  def process_xml(report, xml_content)
    invoice_info = xml_content.dig('NFe', 'infNFe')

    if invoice_info.nil?
      report.status = 'failed'
      report.failure_reason = "Informações indisponíveis para processamento."
      report.save
      return ScheduleFailedReportDeletionJob.set(wait: 10.minutes).perform_later(report)
    end

    invoice =
      ProcessReportFilesHelper.create_invoice(report, invoice_info['ide'],
                                              invoice_info.dig('total', 'ICMSTot'))
    return invoice[:errors] if invoice[:errors].present?

    ProcessReportFilesHelper.create_issuer(report, invoice.id, invoice_info['emit'])
    ProcessReportFilesHelper.create_recipient(report, invoice.id, invoice_info['dest'])
    ProcessReportFilesHelper.create_products(report, invoice.id, invoice_info['det'])
  end
end

