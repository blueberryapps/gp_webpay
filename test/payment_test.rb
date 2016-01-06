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

  describe '#digest_attributes' do
    let(:params) do
      {
        'OPERATION'      => 'CREATE_ORDER',
        'ORDERNUMBER'    => 1001,
        'MERORDERNUM'    => '123d',
        'test'           => 'test'
      }
    end
    let(:expected_attributes) { ['OPERATION', 'ORDERNUMBER', 'MERORDERNUM'] }

    it 'filters only allowed attributes' do
      assert_equal payment.send(:digest_attributes, params), expected_attributes
    end
  end
end
