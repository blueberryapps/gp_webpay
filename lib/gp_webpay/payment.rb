module GpWebpay
  module Payment
    extend ActiveSupport::Concern

    DIGEST_ALLOWED_ATTRIBUTES = %w(OPERATION ORDERNUMBER MERORDERNUM PRCODE
                                   SRCODE RESULTTEXT)

    included do
      attr_accessor :redirect_url
    end

    def deposit_flag
      1
    end

    def merchant_number
      config.merchant_number
    end

    def operation
      'CREATE_ORDER'
    end

    def pay_url(options = {})
      self.redirect_url = options[:redirect_url]

      "#{config.pay_url}?#{payment_attributes_with_digest.to_param}"
    end

    def success?(params)
      verified_response?(params) &&
        params['PRCODE'] == '0' && params['SRCODE'] == '0'
    end

    private

    def config
      GpWebpay.config
    end

    def digest
      sign = merchant_key.sign(OpenSSL::Digest::SHA1.new, digest_text)
      Base64.encode64(sign).gsub("\n", '')
    end

    def digest_text
      payment_attributes.values.join('|')
    end

    def digest_verification(params)
      digest_attributes(params).map { |key| params[key] }.join('|')
    end

    def digest_attributes(params)
      DIGEST_ALLOWED_ATTRIBUTES.reject { |k| !params.keys.include?(k) }
    end

    def digest1_verification(params)
      digest_verification(params) + "|#{config.merchant_number}"
    end

    def payment_attributes
      @payment_attributes ||= PaymentAttributes.new(self).to_h
    end

    def payment_attributes_with_digest
      payment_attributes.merge('DIGEST' => digest)
    end

    def verified_response?(params)
      verify_digest(params['DIGEST'], digest_verification(params)) &&
        verify_digest(params['DIGEST1'], digest1_verification(params))
    end

    def verify_digest(signature, data)
      gpe_key.verify(OpenSSL::Digest::SHA1.new, Base64.decode64(signature), data)
    end

    def merchant_key
      @merchant_key ||= begin
        pem = config.merchant_pem || File.read(config.merchant_pem_path)
        OpenSSL::PKey::RSA.new(pem, config.merchant_password)
      end
    end

    def gpe_key
      @gpe_key ||= begin
        pem = File.read config.gpe_pem_path
        OpenSSL::X509::Certificate.new(pem).public_key
      end
    end
  end
end
