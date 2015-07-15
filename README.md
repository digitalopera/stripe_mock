# StripeMock - WIP

# This gem is Incomplete!

Only Transfers is complete

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stripe_mock'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stripe_mock

## How does StripeMock work?

StripeMock uses Webmock to hijack the request to the Stripe servers and return the
corresponding Stripe response.

### Setup

To capture requests to Strip simply add these lines to your spec file

```ruby
before(:all) do
  StripeMock.capture_requests
end
```

### Mocked Requests

To get a mocked response, just use the Stripe gem as you normally would.

```ruby
Stipe::Transfer.all

# #<Stripe::ListObject:0x3fe634d74498> JSON: {
#   "object": "list",
#   "url": "/v1/transfers",
#   "has_more": false,
#   "data": [
#     #<Stripe::Transfer id=tr_16DA2VCKrsNpguPAW93AVKPk 0x00000a> JSON: {
#       "id": "tr_16DA2VCKrsNpguPAW93AVKPk",
#       "object": "transfer",
#       "created": 1434184255,
#       "date": 1434240000,
#       ...
#     },
#     #<Stripe::Transfer[...] ...>,
#     #<Stripe::Transfer[...] ...>
#   ]
# }
```

##### Getting Transfer Failure Codes

To get the transfer failure_code filled in, just use the desired failure_code as the id of the transfer. EX:

```ruby
Stripe::Transfer.retrieve('insufficient_funds')
```

All codes are listed here: [https://stripe.com/docs/api/ruby#transfer_failures](https://stripe.com/docs/api/ruby#transfer_failures)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/digitalopera/stripe_mock.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
