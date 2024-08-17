module CsvGenerator
  class Report
    def self.call(report_id)
      invoices = Invoice.includes(:products).where(report_id: report_id)
      return if invoices.empty?

      products = invoices.map(&:products)
      max_products = products.map(&:size).max
      max_products += 1 if max_products == 0

      headers = CsvExportHelper.invoice_headers.values
      (1..max_products).each do |i|
        products_headers = CsvExportHelper.product_headers.values.map do |header|
          header.prepend("Produto #{i} - ")
        end
        headers << products_headers
      end

      CSV.generate(headers: true) do |csv|
        csv << headers.flatten

        invoices.find_each do |invoice|
          invoice_values = CsvExportHelper.invoice_values(invoice)
          invoice.products.find_each do |product|
            invoice_values <<  CsvExportHelper.product_values(product)
          end

          csv << invoice_values.flatten
        end
      end
    end
  end
end
