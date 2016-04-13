module GpWebpay
  class Verification
    def initialize(payment_attributes, verification_attrs=nil)
      @payment_attributes = payment_attributes
      @verification_attrs = verification_attrs
    end

    def verified_response?(params)
      verify_digest(params['DIGEST'], digest_verification(params)) &&
        verify_digest(params['DIGEST1'], digest1_verification(params))
    end

    def payment_attributes_with_digest
      @payment_attributes.merge('DIGEST' => digest)
    end

    def digest
      sign = merchant_key.sign(OpenSSL::Digest::SHA1.new, digest_text)
      Base64.encode64(sign).gsub("\n", '')
    end

    private

    def config
      GpWebpay.config
    end

    def digest_text
      @payment_attributes.values.join('|')
    end

    def digest_verification(params)
      @verification_attrs.map { |key| params[key] }.join('|')
    end

    def digest1_verification(params)
      digest_verification(params) + "|#{config.merchant_number}"
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
