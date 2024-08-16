module ProcessReportFilesHelper
  def self.create_invoice(report_id, invoice_data, taxes_data)
    invoice =
      Invoice.new(serie: invoice_data['serie'].to_i, number: invoice_data['nNF'].to_i,
                  emitted_at: invoice_data['dhEmi'].to_datetime,
                  total_values: taxes_data, report_id: report_id)
    if !invoice.save
      return { errors: invoice.errors.full_messages.join(', ') }
    end

    invoice
  end

  def self.create_issuer(invoice_id, data)
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
    issuer.save!
  end

  def self.create_recipient(invoice_id, data)
    location = data['enderDest']

    recipient =
      Recipient.new(cnpj: data['CNPJ'], name: data['xNome'], address_street: location['xLgr'],
                    address_number: location['nro'].to_i, address_complement: location['xCpl'],
                    neighborhood: location['xBairro'], city_code: location['cMun'],
                    city: location['xMun'], state: location['UF'], postal_code: location['CEP'],
                    country_code: location['cPais'], country: location['xPais'],
                    invoice_id: invoice_id)
    recipient.save!
  end

  def self.create_products(invoice_id, data)
    data.each do |item|
      product = item['prod']
      product =
        Product.new(name: product['xProd'], ncm: product['NCM'], cfop: product['CFOP'],
                    unity_commercialized: product['uCom'],
                    quantity_commercialized: product['qCom'].to_i,
                    unity_value: product['vUnCom'].to_f.truncate(2),
                    value: product['vProd'].to_f.truncate(2), taxed_unity: product['uTrib'],
                    taxed_unity_value: product['vUnTrib'].to_f.truncate(2),
                    quantity_taxed: product['qTrib'].to_i, invoice_id: invoice_id)
      product.save!
    end
  end
end
