module CsvExportHelper
  def self.invoice_headers
    {
      number: 'Nota - Número',
      serie: 'Número de série',
      emitted_at: 'Data e Hora de Emissão',
      total_icms: 'Valor Total - ICMS',
      total_ipi: 'Valor Total - IPI',
      total_pis: 'Valor Total - PIS',
      total_cofins: 'Valor Total - COFINS',
      total_products: 'Valor Total - Produtos',
      total_taxed: 'Valor Total - Tributado',
      emit_cnpj: 'Emitente - CNPJ',
      emit_name: 'Emitente - Nome',
      emit_fantasy_name: 'Emitente - Nome fantasia',
      emit_phone_number: 'Emitente - Telefone',
      emit_neighborhood: 'Emitente - Bairro',
      emit_address_street: 'Emitente - Logradouro',
      emit_address_number: 'Emitente - Número',
      emit_address_complement: 'Emitente - Complemento',
      emit_city_code: 'Emitente - Código município',
      emit_city: 'Emitente - Cidade',
      emit_country_code: 'Emitente - Código país',
      emit_country: 'Emitente - País',
      emit_postal_code: 'Emitente - CEP',
      emit_state: 'Emitente - Estado',
      emit_state_subscription: 'Emitente - Inscrição Estadual',
      emit_tax_regime_code: 'Emitente - Código de regime tributário',
      dest_cnpj: 'Destinatário - CNPJ',
      dest_name: 'Destinatário - Nome',
      dest_neighborhood: 'Destinatário - Bairro',
      dest_address_street: 'Destinatário - Logradouro',
      dest_address_number: 'Destinatário - Número',
      dest_address_complement: 'Destinatário - Complemento',
      dest_city_code: 'Destinatário - Código município',
      dest_city: 'Destinatário - Cidade',
      dest_country_code: 'Destinatário - Código país',
      dest_country: 'Destinatário - País',
      dest_postal_code: 'Destinatário - CEP',
      dest_state: 'Destinatário - Estado'
    }.freeze
  end

  def self.invoice_values(invoice)
    issuer = invoice.issuer
    recipient = invoice.recipient

    CsvExportHelper.invoice_headers.keys.map do |header|
      case header
      when :number then invoice.number
      when :serie then invoice.serie
      when :emitted_at then invoice.emitted_at.strftime('%d/%m/%Y %H:%M:%S')
      when :total_icms then invoice.total_values['vICMS']
      when :total_ipi then invoice.total_values['vIPI']
      when :total_pis then invoice.total_values['vPIS']
      when :total_cofins then invoice.total_values['vCOFINS']
      when :total_products then invoice.total_values['vProd']
      when :total_taxed then invoice.total_values['vTotTrib']
      when :emit_cnpj then issuer.cnpj
      when :emit_name then issuer.name
      when :emit_fantasy_name then issuer.fantasy_name
      when :emit_phone_number then issuer.phone_number
      when :emit_neighborhood then issuer.neighborhood
      when :emit_address_street then issuer.address_street
      when :emit_address_number then issuer.address_number
      when :emit_address_complement then issuer.address_complement
      when :emit_city_code then issuer.city_code
      when :emit_city then issuer.city
      when :emit_country_code then issuer.country_code
      when :emit_country then issuer.country
      when :emit_postal_code then issuer.postal_code
      when :emit_state then issuer.state
      when :emit_state_subscription then issuer.state_subscription
      when :emit_tax_regime_code then issuer.tax_regime_code
      when :dest_cnpj then recipient.cnpj
      when :dest_name then recipient.name
      when :dest_neighborhood then recipient.neighborhood
      when :dest_address_street then recipient.address_street
      when :dest_address_number then recipient.address_number
      when :dest_address_complement then recipient.address_complement
      when :dest_city_code then recipient.city_code
      when :dest_city then recipient.city
      when :dest_country_code then recipient.country_code
      when :dest_country then recipient.country
      when :dest_postal_code then recipient.postal_code
      when :dest_state then recipient.state
      end
    end
  end

  def self.product_headers
    {
      name: 'Nome',
      ncm: 'NCM',
      cfop: 'CFOP',
      unity_commercialized: 'Unidade comercializada',
      quantity_commercialized: 'Quantidade comercializada',
      unity_value: 'Valor unitário'
    }.freeze
  end

  def self.product_values(product)
    CsvExportHelper.product_headers.keys.map do |header|
      case header
      when :name then product.name
      when :ncm then product.ncm
      when :cfop then product.cfop
      when :unity_commercialized then product.unity_commercialized
      when :quantity_commercialized then product.quantity_commercialized
      when :unity_value then product.unity_value
      end
    end
  end
end
