module GpWebpay
  class PaymentAttributes

    KEYS = %w(MERCHANTNUMBER OPERATION ORDERNUMBER AMOUNT CURRENCY DEPOSITFLAG
              MERORDERNUM URL DESCRIPTION MD)

    OPTIONAL_KEYS = %w(MERORDERNUM DESCRIPTION MD)

    TRANSITIONS = {
      'MERCHANTNUMBER' => :merchant_number,
      'ORDERNUMBER'    => :order_number,
      'AMOUNT'         => :amount_in_cents,
      'DEPOSITFLAG'    => :deposit_flag,
      'MERORDERNUM'    => :merchant_order_number,
      'URL'            => :redirect_url,
      'MD'             => :merchant_description
    }

    def initialize(payment)
      @payment = payment
    end

    def to_h
      KEYS.each_with_object({}) do |key, hash|
        method = TRANSITIONS[key] || key.downcase.to_sym

        if @payment.respond_to?(method)
          hash[key] = @payment.public_send(method)
        elsif !OPTIONAL_KEYS.include?(key)
          method_missing(method)
        end

        hash
      end
    end
  end
end
