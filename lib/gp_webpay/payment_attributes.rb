module GpWebpay
  class PaymentAttributes

    KEYS = %w(MERCHANTNUMBER OPERATION ORDERNUMBER AMOUNT CURRENCY DEPOSITFLAG URL DESCRIPTION MD USERPARAM1)

    WS_KEYS = %w(MESSAGEID BANKID MERCHANTNUMBER ORDERNUMBER)

    RECCURING_KEYS = %w(MESSAGEID BANKID MERCHANTNUMBER ORDERNUMBER MASTERORDERNUMBER MERORDERNUM AMOUNT CURRENCY)

    OPTIONAL_KEYS = %w(MERORDERNUM DESCRIPTION MD)

    MASTER_KEYS = %w(USERPARAM1)

    TRANSITIONS = {
      'MERCHANTNUMBER' => :merchant_number,
      'ORDERNUMBER'    => :order_number,
      'MASTERORDERNUMBER' => :master_order_number,
      'AMOUNT'         => :amount_in_cents,
      'DEPOSITFLAG'    => :deposit_flag,
      'MERORDERNUM'    => :merchant_order_number,
      'URL'            => :redirect_url,
      'MD'             => :merchant_description,
      'USERPARAM1'     => :user_param,
      'MESSAGEID'      => :message_id,
      'BANKID'         => :bank_id
    }

    def initialize(payment, ws_flag = false, type = '')
      @payment = payment
      @ws_flag = ws_flag
      @type = type
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
        case @type
        when 'detail', 'state'
          return WS_KEYS
        when 'recurring'
          return RECCURING_KEYS
        else
          return WS_KEYS # TBD
        end
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
