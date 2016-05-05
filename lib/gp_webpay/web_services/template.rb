module GpWebpay
  module WebServices
    class Template

      ##
      # Generated XML request body
      # <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:core="http://gpe.cz/pay/pay-ws/core">
      #   <soapenv:Header/>
      #   <soapenv:Body>
      #     <core:echo/>
      #   </soapenv:Body>
      # </soapenv:Envelope>
      ##
      def echo
        xml = ::Nokogiri::XML::Builder.new(:encoding => 'utf-8') do |xml|
          xml.send('soapenv:Envelope', 'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/', 'xmlns:core' => 'http://gpe.cz/pay/pay-ws/core') {
            xml.send('soapenv:Header')
            xml.send('soapenv:Body') {
              xml.send('core:echo')
            }
          }
        end.to_xml
      end

      ##
      # <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:core="http://gpe.cz/pay/pay-ws/core" xmlns:type="http://gpe.cz/pay/pay-ws/core/type">
      #   <soapenv:Header/>
      #   <soapenv:Body>
      #     <core:processRecurringPayment>
      #       <core:recurringPaymentRequest>
      #         <type:messageId>A111111111111111</type:messageId>
      #         <type:acquirer>0100</type:acquirer>  // use 0100 for KB
      #         <type:merchantNumber>9999999022</type:merchantNumber> // stored in configuration
      #         <type:orderNumber>2</type:orderNumber> // unique order number for merchant
      #         <type:masterOrderNumber>1</type:masterOrderNumber>
      #         <type:merchantOrderNumber>2</type:merchantOrderNumber>
      #         <!--Optional:-->
      #         <type:amount>80</type:amount>
      #         <!--Optional:-->
      #         <type:currencyCode>203</type:currencyCode>
      #         <type:signature>KGU4751QSU12 ... </type:signature>
      #       </core:recurringPaymentRequest>
      #     </core:processRecurringPayment>
      #   </soapenv:Body>
      # </soapenv:Envelope>
      ##
      def process_recurring_payment(attributes = {})
        xml = ::Nokogiri::XML::Builder.new(:encoding => 'utf-8') do |xml|
          xml.send('soapenv:Envelope', 'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/', 'xmlns:core' => 'http://gpe.cz/pay/pay-ws/core', 'xmlns:type' => 'http://gpe.cz/pay/pay-ws/core/type') {
            xml.send('soapenv:Header')
            xml.send('soapenv:Body') {
              xml.send('core:processRecurringPayment') {
                xml.send('core:recurringPaymentRequest') {
                  xml.send('type:messageId', attributes[:message_id])
                  xml.send('type:acquirer', '0100')
                  xml.send('type:merchantNumber', attributes[:merchant_number])
                  xml.send('type:orderNumber', attributes[:order_number])
                  xml.send('type:masterOrderNumber', attributes[:master_order_number])
                  xml.send('type:merchantOrderNumber', attributes[:merchant_order_number])
                  xml.send('type:amount', attributes[:amount])
                  xml.send('type:currencyCode', attributes[:currency])
                  xml.send('type:signature', attributes[:digest])
                }
              }
            }
          }
        end.to_xml
      end

      ##
      # <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:core="http://gpe.cz/pay/pay-ws/core" xmlns:type="http://gpe.cz/pay/pay-ws/core/type">
      #   <soapenv:Header/>
      #   <soapenv:Body>
      #     <core:getOrderDetail>
      #       <core:orderDetailRequest>
      #         <type:messageId>A111111111111111</type:messageId>
      #         <type:acquirer>0100</type:acquirer>
      #         <type:merchantNumber>9999999022</type:merchantNumber>
      #         <type:orderNumber>1</type:orderNumber>
      #         <type:signature>KGU4751QSU12 ... </type:signature>
      #       </core:orderDetailRequest>
      #     </core:getOrderDetail>
      #   </soapenv:Body>
      # </soapenv:Envelope>
      ##
      def get_order_detail(attributes = {})
        xml = ::Nokogiri::XML::Builder.new(:encoding => 'utf-8') do |xml|
          xml.send('soapenv:Envelope', 'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/', 'xmlns:core' => 'http://gpe.cz/pay/pay-ws/core', 'xmlns:type' => 'http://gpe.cz/pay/pay-ws/core/type') {
            xml.send('soapenv:Header')
            xml.send('soapenv:Body') {
              xml.send('core:getOrderDetail') {
                xml.send('core:orderDetailRequest') {
                  xml.send('type:messageId', attributes[:message_id])
                  xml.send('type:acquirer', '0100')
                  xml.send('type:merchantNumber', attributes[:merchant_number])
                  xml.send('type:orderNumber', attributes[:order_number])
                  xml.send('type:signature', attributes[:digest])
                }
              }
            }
          }
        end.to_xml
      end

      ##
      # <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:core="http://gpe.cz/pay/pay-ws/core" xmlns:type="http://gpe.cz/pay/pay-ws/core/type">
      #   <soapenv:Header/>
      #   <soapenv:Body>
      #     <core:getOrderState>
      #       <core:orderStateRequest>
      #         <type:messageId>A111111111111111</type:messageId>
      #         <type:acquirer>0100</type:acquirer>
      #         <type:merchantNumber>9999999022</type:merchantNumber>
      #         <type:orderNumber>1</type:orderNumber>
      #         <type:signature>KGU4751QSU12 ... </type:signature>
      #       </core:orderStateRequest>
      #     </core:getOrderState>
      #   </soapenv:Body>
      # </soapenv:Envelope>
      ##
      def get_order_state(attributes = {})
        xml = ::Nokogiri::XML::Builder.new(:encoding => 'utf-8') do |xml|
          xml.send('soapenv:Envelope', 'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/', 'xmlns:core' => 'http://gpe.cz/pay/pay-ws/core', 'xmlns:type' => 'http://gpe.cz/pay/pay-ws/core/type') {
            xml.send('soapenv:Header')
            xml.send('soapenv:Body') {
              xml.send('core:getOrderState') {
                xml.send('core:orderStateRequest') {
                  xml.send('type:messageId', attributes[:message_id])
                  xml.send('type:acquirer', '0100')
                  xml.send('type:merchantNumber', attributes[:merchant_number])
                  xml.send('type:orderNumber', attributes[:order_number])
                  xml.send('type:signature', attributes[:digest])
                }
              }
            }
          }
        end.to_xml
      end
    end
  end
end
