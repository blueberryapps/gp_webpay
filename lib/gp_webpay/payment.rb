module GpWebpay
  module Payment
    extend ActiveSupport::Concern

    included do
      attr_accessor :redirect_url
    end

    def deposit_flag
      1
    end

    def user_param
      'R'
    end

    def payment_type
      super || 'default'
    end

    def merchant_number
      config.merchant_number
    end

    def operation
      'CREATE_ORDER'
    end

    def pay_url(options = {})
      self.redirect_url = options[:redirect_url]

      "#{config.pay_url}?#{pay_verification.payment_attributes_with_digest.to_param}"
    end

    def success?(params)
      pay_verification.verified_response?(params) &&
        params['PRCODE'] == '0' && params['SRCODE'] == '0'
    end

    private

    def pay_verification_attrs
      %w(OPERATION ORDERNUMBER PRCODE SRCODE RESULTTEXT)
    end

    def pay_attributes
      @pay_attributes ||= PaymentAttributes.new(self).to_h
    end

    def config
      GpWebpay.config
    end

    def pay_verification
      ::GpWebpay::Verification.new(pay_attributes, pay_verification_attrs)
    end
  end
end
