require 'test_helper'

GpWebpay.configure do |config|
  config.merchant_number = 1234
end

class Payment
  include GpWebpay::Payment

  def initialize
    self.redirect_url = 'https://test'
  end

  def order_number
    1001
  end

  def payment_type
    'default'
  end

  def amount_in_cents
    100
  end

  def currency
    103
  end
end

class PaymentWithDescription < Payment
  def description
    'Description of payment'
  end
end

class PaymentTest < Minitest::Spec
  let(:payment)            { Payment.new }
  let(:payment_attributes) { GpWebpay::PaymentAttributes.new(payment) }

  it 'build correct hash with all attributes' do
    assert_equal payment_attributes.to_h.to_s, {
      'MERCHANTNUMBER' => 1234,
      'OPERATION'      => 'CREATE_ORDER',
      'ORDERNUMBER'    => 1001,
      'AMOUNT'         => 100,
      'CURRENCY'       => 103,
      'DEPOSITFLAG'    => 1,
      'URL'            => 'https://test'
    }.to_s
  end

  describe 'with description' do
    let(:payment) { PaymentWithDescription.new }

    it 'add DESCRIPTION to hash' do
      assert_equal payment_attributes.to_h.to_s, {
        'MERCHANTNUMBER' => 1234,
        'OPERATION'      => 'CREATE_ORDER',
        'ORDERNUMBER'    => 1001,
        'AMOUNT'         => 100,
        'CURRENCY'       => 103,
        'DEPOSITFLAG'    => 1,
        'URL'            => 'https://test',
        'DESCRIPTION'    => 'Description of payment'
      }.to_s
    end
  end
end
