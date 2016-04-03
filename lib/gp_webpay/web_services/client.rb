module GpWebpay
  module WebServices
    class Client
      attr_accessor :attribute, :url

      def initialize(attribute)
        @attribute = attribute
        if GpWebpay::Configuration.config.production?
          @url = 'https://3dsecure.gpwebpay.com/pay-ws/PaymentService'
        else
          @url = 'https://test.3dsecure.gpwebpay.com/pay-ws/PaymentService'
        end
      end

      def send(request_xml)
        request = Curl::Easy.new(url)
        request.http_post(request_xml)
        request.headers['Content-Type'] = 'text/dxml'
        request.perform
        request
      end

      ##
      # Expected output
      # <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
      #   <soapenv:Body>
      #     <ns2:echoResponse xmlns:ns2="http://gpe.cz/pay/pay-ws/core" xmlns="http://gpe.cz/pay/pay-ws/core/type"/>
      #   </soapenv:Body>
      # </soapenv:Envelope>
      ##
      def echo
        send(GpWebpay::WebServices::Template.new.echo)
        # Hash.from_xml(Nokogiri::XML(send(GpWebpay::WebServices::Echo.new.request.to_xml).body_str).to_s)
      end
    end
  end
end
