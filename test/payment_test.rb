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
end
