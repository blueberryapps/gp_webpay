require 'test_helper'

class Payment
  include GpWebpay::Payment
end

class PaymentTest < Minitest::Spec
  let(:payment) { Payment.new }

  it 'have all public methods' do
    assert payment.respond_to?(:pay_url)
    assert payment.respond_to?(:success?)
  end

  describe '#digest_verification' do
    let(:params) do
      {
        'ORDERNUMBER' => 1001,
        'MERORDERNUM' => '123d',
        'OPERATION'   => 'CREATE_ORDER',
        'test'        => 'test'
      }
    end

    it 'filters only properly sorted allowed attributes' do
      assert_equal payment.send(:digest_verification, params),
                   'CREATE_ORDER|1001|123d'
    end
  end
end
