module ProcessReportFilesHelper
  def self.create_invoice(report, invoice_data, taxes_data)
    invoice =
      Invoice.new(serie: invoice_data['serie'].to_i, number: invoice_data['nNF'].to_i,
                  emitted_at: invoice_data['dhEmi'].to_datetime,
                  total_values: taxes_data, report_id: report.id)

    unless invoice.save
      invoice_number = invoice_data['nNF']
      failure_reason = "Processamento da nota fiscal #{invoice_number || ''} " \
                       'apresentou um erro.'
      failure_reason.strip.squeeze!(' ')
      report.status = 'failed'
      report.failure_reason = failure_reason
      report.save
      ScheduleFailedReportDeletionJob.set(wait: 10.minutes).perform_later(report)
      return { errors: invoice.errors.full_messages.join(', ') }
    end

    invoice
  end

  def self.create_issuer(report, invoice_id, data)
    location = data['enderEmit']

    issuer =
      Issuer.new(cnpj: data['CNPJ'], name: data['xNome'], fantasy_name: data['xFant'],
                 state_subscription: data['IE'], tax_regime_code: data['CRT'],
                 address_street: location['xLgr'], address_number: location['nro'].to_i,
                 address_complement: location['xCpl'], neighborhood: location['xBairro'],
                 city_code: location['cMun'], city: location['xMun'], state: location['UF'],
                 postal_code: location['CEP'], country_code: location['cPais'],
                 country: location['xPais'], phone_number: location['fone'],
                 invoice_id: invoice_id)
    
    unless issuer.save
      report.status = 'failed'
      report.failure_reason = 'Dados do emissor apresentaram um erro. ' \
                              "#{issuer.errors.full_messages.join(', ')}"
      report.save
      return ScheduleFailedReportDeletionJob.set(wait: 10.minutes).perform_later(report)
    end
     
    issuer
  end

  def self.create_recipient(report, invoice_id, data)
    location = data['enderDest']

    recipient =
      Recipient.new(cnpj: data['CNPJ'], name: data['xNome'], address_street: location['xLgr'],
                    address_number: location['nro'].to_i, address_complement: location['xCpl'],
                    neighborhood: location['xBairro'], city_code: location['cMun'],
                    city: location['xMun'], state: location['UF'], postal_code: location['CEP'],
                    country_code: location['cPais'], country: location['xPais'],
                    invoice_id: invoice_id)

    unless recipient.save
      report.status = 'failed'
      report.failure_reason = 'Dados do destinatário apresentaram um erro. ' \
                              "#{recipient.errors.full_messages.join(', ')}"
      report.save
      return ScheduleFailedReportDeletionJob.set(wait: 10.minutes).perform_later(report)
    end

    recipient
  end

  def self.create_products(report, invoice_id, data)
    data.each.with_index do |item, index|
      product = item['prod']
      product =
        Product.new(name: product['xProd'], ncm: product['NCM'], cfop: product['CFOP'],
                    unity_commercialized: product['uCom'],
                    quantity_commercialized: product['qCom'].to_i,
                    unity_value: product['vUnCom'].to_f.truncate(2),
                    value: product['vProd'].to_f.truncate(2), taxed_unity: product['uTrib'],
                    taxed_unity_value: product['vUnTrib'].to_f.truncate(2),
                    quantity_taxed: product['qTrib'].to_i, invoice_id: invoice_id)

      unless product.save 
        report.status = 'failed'
        report.failure_reason = 'Dados relacionados a um produto apresentaram um erro. ' \
                                "#{product.errors.full_messages.join(', ')}"
        report.save
        ScheduleFailedReportDeletionJob.set(wait: 10.minutes).perform_later(report)
      end
    end
  end
end
