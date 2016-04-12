require 'active_support/configurable'

module GpWebpay
  # Configures global settings for Kaminari
  #   GpWebpay.configure do |config|
  #     config.default_per_page = 10
  #   end
  def self.configure(&block)
    yield @config ||= GpWebpay::Configuration.new
  end

  # Global settings for Kaminari
  def self.config
    @config
  end

  # need a Class for 3.0
  class Configuration #:nodoc:
    include ActiveSupport::Configurable
    config_accessor :merchant_number do nil; end
    config_accessor :merchant_pem do nil; end
    config_accessor :merchant_pem_path do nil; end
    config_accessor :merchant_password do nil; end
    config_accessor :gpe_pem_path do nil; end
    config_accessor :environment do
      defined?(Rails) && Rails.env || 'test'
    end

    def param_name
      config.param_name.respond_to?(:call) ? config.param_name.call : config.param_name
    end

    def pay_url
      if production?
        'https://3dsecure.gpwebpay.com/kb/order.do'
      else
        'https://test.3dsecure.gpwebpay.com/kb/order.do'
      end
    end

    def web_services_url
      if production?
        'https://3dsecure.gpwebpay.com/pay-ws/PaymentService'
      else
        'https://test.3dsecure.gpwebpay.com/pay-ws/PaymentService'
      end
    end

    def gpe_pem_path
      file_name = production? ? 'muzo.signing_prod.pem' : 'muzo.signing_test.pem'

      File.expand_path("../../../certs/#{file_name}", __FILE__)
    end

    def production?
      config.environment == 'production'
    end

    # define param_name writer (copied from AS::Configurable)
    writer, line = 'def param_name=(value); config.param_name = value; end', __LINE__
    singleton_class.class_eval writer, __FILE__, line
    class_eval writer, __FILE__, line
  end
end
