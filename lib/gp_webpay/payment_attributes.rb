module GpWebpay
  class PaymentAttributes

    KEYS = %w(MERCHANTNUMBER OPERATION ORDERNUMBER AMOUNT CURRENCY DEPOSITFLAG
              MERORDERNUM URL DESCRIPTION MD USERPARAM1)

    WS_KEYS = %w(MESSAGEID BANKID MERCHANTNUMBER ORDERNUMBER)

    OPTIONAL_KEYS = %w(MERORDERNUM DESCRIPTION MD)

    MASTER_KEYS = %w(USERPARAM1)

    TRANSITIONS = {
      'MERCHANTNUMBER' => :merchant_number,
      'ORDERNUMBER'    => :order_number,
      'AMOUNT'         => :amount_in_cents,
      'DEPOSITFLAG'    => :deposit_flag,
      'MERORDERNUM'    => :merchant_order_number,
      'URL'            => :redirect_url,
      'MD'             => :merchant_description,
      'USERPARAM1'     => :user_param,
      'MESSAGEID'      => :message_id,
      'BANKID'         => :bank_id
    }

    def initialize(payment, ws_flag = false)
      @payment = payment
      @ws_flag = ws_flag
    end

    def keys
      case @payment.payment_type
      when 'master'
        if @ws_flag
          return WS_KEYS
        else
          return KEYS
        end
      when 'recurring'
        return WS_KEYS
      else
        return KEYS.reject { |k| MASTER_KEYS.include?(k) }
      end
    end

    def to_h
      keys.each_with_object({}) do |key, hash|
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
