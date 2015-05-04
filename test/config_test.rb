require 'test_helper'

GpWebpay.configure do |config|
  config.merchant_number    = 1234
  config.merchant_pem_path  = 'certs/file.pem'
  config.merchant_password  = 'password'
end

class ConfigTest < Minitest::Spec
  let(:config) { GpWebpay.config }

  it 'store setup to config' do
    assert config.merchant_number == 1234
    assert config.merchant_pem_path == 'certs/file.pem'
    assert config.merchant_password == 'password'
    assert config.production? == false
    assert config.pay_url == 'https://test.3dsecure.gpwebpay.com/kb/order.do'
    assert config.gpe_pem_path.end_with? 'certs/muzo.signing_test.pem'
  end

  it 'could read certificate file' do
    assert File.read(config.gpe_pem_path).is_a?(String)
  end

  describe 'production environment' do
    it 'return test url' do
      config.stub :production?, true do
        assert config.pay_url == 'https://3dsecure.gpwebpay.com/kb/order.do'
        assert config.gpe_pem_path.end_with? 'certs/muzo.signing_prod.pem'
      end
    end

    it 'could read certificate file' do
      assert File.read(config.gpe_pem_path).is_a?(String)
    end
  end
end
