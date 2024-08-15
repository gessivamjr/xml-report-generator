# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Report.create(title: 'Relatório 1', user_id: 1)
Invoice.create(serie: 4,
               number: 500778,
               emitted_at: '2024-08-12T14:21:59-03:00',
               total_icms: 330.25,
               total_ipi: 250.00,
               total_pis: 0.00,
               total_cofins: 0.00,
               total_values: {"vBC"=>"2752.06",
                              "vICMS"=>"330.25",
                              "vICMSDeson"=>"0.00",
                              "vFCP"=>"0.00",
                              "vBCST"=>"0.00",
                              "vST"=>"0.00",
                              "vFCPST"=>"0.00",
                              "vFCPSTRet"=>"0.00",
                              "vProd"=>"2502.06",
                              "vFrete"=>"0.00",
                              "vSeg"=>"0.00",
                              "vDesc"=>"0.00",
                              "vII"=>"0.00",
                              "vIPI"=>"250.00",
                              "vIPIDevol"=>"0.00",
                              "vPIS"=>"0.00",
                              "vCOFINS"=>"0.00",
                              "vOutro"=>"0.00",
                              "vNF"=>"2752.06",
                              "vTotTrib"=>"405.00"},
               report_id: 1)
Issuer.create(cnpj: '60124452000107', name: 'MAINO SISTEMAS DE INFORMATICA LTD', fantasy_name: 'MAINO SISTEMAS',
              neighborhood: 'SAO FRANCISCO', address_street: 'RUA MARCOS MORO', address_number: 16,
              address_complement: 'SL 808', city_code: '3304557', city: 'RIO DE JANEIRO', state: 'RJ',
              postal_code: '80530080', country: 'BRASIL', country_code: '1058', phone_number: '211234567899',
              state_subscription: '78205377', tax_regime_code: '3', invoice_id: 1)
Recipient.create(cnpj: '08370779000149', name: 'MAINO CLIENTE', address_street: 'Rua Augusta', address_number: 50,
                 neighborhood: 'Consolacao', city_code: '3550308', city: 'SAO PAULO', state: 'SP',
                 postal_code: '01305901', country: 'BRASIL', country_code: '1058', invoice_id: 1)
Product.create(name: 'BALAO ESTRELA', ncm: '34013000', cfop: '6102', unity_commercialized: 'UN',
               quantity_commercialized: 1, unity_value: 2.06, invoice_id: 1)
Product.create(name: 'Batata frita', ncm: '02013000', cfop: '6102', unity_commercialized: 'BALDE',
               quantity_commercialized: 100, unity_value: 25, invoice_id: 1)

