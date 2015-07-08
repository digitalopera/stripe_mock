# StripeMock - WIP

# This gem is Incomplete!

## Installation

This gem has not been released publically yet. So these installation methods will not work yet.

Add this line to your application's Gemfile:

```ruby
gem 'stripe_mock'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stripe_mock

## Usage

StripeMock uses Webmock to hijack the request to the Stripe server and return the corresponding Stripe response.

## Versioning

Versions correspond Stripe's API versioning. So if Stripe's version is 2015-07-07, StripeMock's version will be 2015.07.07.0.
In the case a patch needs to be made to StipeMock, it will be identified by an incremented right hand number. Example: 2015.07.07.*1*

### Setup

To capture requests to Strip simply add these lines to your spec files

```ruby
before(:all) do
  StripeMock.start
end

after(:all) do
  StripeMock.stop
end
```

Or, if you want to mock Stripe in while in development, make sure that `gem 'stripe_mock'` is within the development block in your
Gemfile. And, add `StripeMock.start` before any Stripe calls that you want to mock.

### Mocked Requests

To get a mocked response, just use the Stripe gem as you normally would.

```ruby
# Setup dummy transfers for Stipe::Transfer.all to pull back. Without first
# creating transfers Stipe::Transfer.all will not return any transfers. The
# same goes for each type of Stripe method
5.times do
  Stipe::Transfer.create
end

Stipe::Transfer.all(limit: 3)

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

Because all StripeMock is doing is intercepting the server call, the Stripe gem will continue to format the response
as it normally would. So if you would expect a Stripe::ListObject in a live environment, StripeMock will do the same.

#### Clearing Mocked Responses

By design, all mocked data is saved in memory within the current thread. That means that they will persist across specs
and you may get some unexpected results. To clear them out after each spec, add this to your spec_helper.

```ruby
RSpec.configure do |c|
  c.before(:each) do
    StripeMock::Session.clear
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/digitalopera/stripe_mock.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
