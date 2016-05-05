require 'nokogiri'
require 'curb'
require 'active_support/core_ext/hash'
require 'gp_webpay/web_services/template'
require 'gp_webpay/web_services/response'

module GpWebpay
  module WebServices
    extend ActiveSupport::Concern

    def send_request(request_xml)
      request = Curl::Easy.new(config.web_services_url)
      request.headers['Content-Type'] = 'text/xml;charset=UTF-8'
      request.http_post(request_xml)
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
    def ws_echo
      get_params_from(send_request(template.echo).body_str)
    end

    def ws_process_recurring_payment
      attributes = request_attributes('recurring')
      raw_response = send_request(template.process_recurring_payment(attributes)).body_str
      get_params_from(raw_response)
    end

    def ws_get_order_detail
      attributes = request_attributes('detail')
      raw_response = send_request(template.get_order_detail(attributes)).body_str
      get_params_from(raw_response)
    end

    def ws_get_order_state
      attributes = request_attributes('state')
      raw_response = send_request(template.get_order_state(attributes)).body_str
      get_params_from(raw_response)
    end

    def message_id
      "#{order_number}0100#{config.merchant_number}"
    end

    def bank_id
      '0100'
    end

    private

    def get_params_from(response)
      hash_response = Hash.from_xml(Nokogiri::XML(response).to_s)['Envelope']['Body']
      first_lvl_key = hash_response.keys.first
      hash_response = hash_response["#{first_lvl_key}"]
      second_lvl_key = hash_response.keys.last
      hash_response = hash_response["#{second_lvl_key}"]
      GpWebpay::WebServices::Response.new(hash_response)
    end

    def request_attributes(type = '')
      {
        digest: ws_verification(type).digest,
        order_number: order_number,
        message_id: message_id,
        merchant_number: config.merchant_number,
        currency: currency,
        amount: amount_in_cents,
        master_order_number: master_order_number,
        merchant_order_number: merchant_order_number
      }
    end

    def config
      GpWebpay.config
    end

    def template
      GpWebpay::WebServices::Template.new
    end

    def ws_attributes(type)
      PaymentAttributes.new(self, true, type).to_h
    end

    def ws_verification(type)
      ::GpWebpay::Verification.new(ws_attributes(type))
    end
  end
end
