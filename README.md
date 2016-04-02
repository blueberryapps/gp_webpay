# GpWebpay

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gp_webpay'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gp_webpay

## Usage

Generate own certificate, put into your repository.

### Initialize

config/initializers/gp_webpay.rb

```ruby
GpWebpay.configure do |config|
  config.merchant_number   = ##########
  config.merchant_pem_path = 'my_cert.pem'
  config.merchant_password = 'password'
end
```

### Payment

```ruby
class Payment
  include GpWebpay::Payment

  def order_number
    id
  end

  def amount_in_cents
    100
  end

  ##
  # implement this method if multiple types of payments required, otherwise default to normal one-time payment
  #
  # allows for 2 types:
  #   default -> normal one-time payment
  #   recurring -> master + recurring payments
  ##
  def payment_type
    case variable
    when one
      return 'master'
    when two
      return 'recurring'
    else
      'default'
    end
  end

  def currency
    840 # CZK = 203, EUR = 978, GBP = 826, HUF = 348, PLN = 985, RUB = 643, USD = 840
  end
end
```

### Controller
```ruby
class OrdersController
  def create
    ...
    payment = Payment.create
    redirect_to payment.pay_url(redirect_url: 'http://example.com/orders/callback')
  end

  def callback
    ...
    payment = Payment.find(params['ORDERNUMBER'])
    if payment.success?(params)
      # Payment success
    else
      # Payment failed
      # params['PRCODE'], params['SRCODE']
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/gp_webpay/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
