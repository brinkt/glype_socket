# GlypeSocket

Wrap HTTP(s) requests through Glype proxy servers

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'glype_socket'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install glype_socket

## Usage

Create an instance of `GlypeSocket::Sock`, do:

```ruby
sock = GlypeSocket::Sock.new({
  host: 'your-glype-proxy-server',
  port: 443
})
```

Fetch `www.google.com`, do:

```ruby
sock.get('https://www.google.com')
```

By default, `GlypeSocket` uses cookies.

If you wish to request a different domain using the same instance, consider clearing the cookies first:

```ruby
sock.clear_cookies!
sock.get('https://www.facebook.com')
```

This code is highly experimental and should not be used in production.

## Development

After checking out the repo, run `bin/setup` to install dependencies.

Then, run `bundle exec rake spec` to run the tests.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
