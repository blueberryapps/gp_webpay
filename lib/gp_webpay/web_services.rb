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
    def ws_echo
      get_params_from(send_request(template.echo).body_str)
    end

    def ws_process_recurring_payment
      # send_request(template.process_recurring_payment(master_order))
    end

    def ws_get_order_detail
      attributes = {
        digest: ws_verification.digest,
        order_number: order_number,
        message_id: message_id,
        merchant_number: config.merchant_number
      }
      get_params_from(send_request(template.get_order_detail(attributes)).body_str)
    end

    def ws_get_order_state
      attributes = {
        digest: digest,
        order_number: order_number,
        message_id: message_id,
        merchant_number: config.merchant_number
      }
      get_params_from(send_request(template.get_order_state(attributes)).body_str)
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

    def config
      GpWebpay.config
    end

    def template
      GpWebpay::WebServices::Template.new
    end

    def ws_attributes
      @pay_attributes ||= PaymentAttributes.new(self, true).to_h
    end

    def ws_verification
      ::GpWebpay::Verification.new(ws_attributes)
    end
  end
end
