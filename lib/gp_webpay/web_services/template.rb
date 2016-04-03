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
    end
  end
end
