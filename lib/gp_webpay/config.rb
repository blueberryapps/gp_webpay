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
    config_accessor :merchant_number
    config_accessor :merchant_pem
    config_accessor :merchant_pem_path
    config_accessor :merchant_password
    config_accessor :gpe_pem_path
    config_accessor :environment
    config_accessor :provider
    config_accessor :gp_webpay_bank

    def param_name
      config.param_name.respond_to?(:call) ? config.param_name.call : config.param_name
    end

    def pay_url
      case config.provider
      when :csob
        if production?
          'https://platebnibrana.csob.cz/pay/entry/merchant'
        else
          'https://iplatebnibrana.csob.cz/pay/entry/merchant'
        end
      when :gp_webpay
        if production?
          "https://3dsecure.gpwebpay.com/#{config.gp_webpay_bank}/order.do"
        else
          "https://test.3dsecure.gpwebpay.com/#{config.gp_webpay_bank}/order.do"
        end
      end
    end

    def gpe_pem_path
      env = production? ? 'prod' : 'test'

      file_name = case config.provider
                  when :csob      then "mips_#{env}.csob.cz.pem"
                  when :gp_webpay then "muzo.signing_#{env}.pem"
                  end

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

  # this is ugly. why can't we pass the default value to config_accessor...?
  configure do |config|
    config.merchant_number    = nil
    config.merchant_pem       = nil
    config.merchant_pem_path  = nil
    config.merchant_password  = nil
    config.environment        = defined?(Rails) && Rails.env || 'test'
    config.provider           = :gp_webpay
    config.gp_webpay_bank     = :kb
  end
end
