# Hashit

Wrapper for Ruby's hashing functions

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hashit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hashit

## Usage

Hashit supports the following hashing algorithms

- md2
- md4
- md5
- sha
- sha1
- sha224
- sha256
- sha384
- sha512

For each of these there is the standard method and a timed method. Both accept a key and some text to hash, but the timed version will create a hash that is only valid for a certain amount of time

### Example
```ruby
hash = Hashit.sha256("key", "some text")
timed_hash = Hashit.timed_sha256("key", "some text")
```

You can then validate those hashes using `matches?`:
```ruby
if Hashit.matches?(hash, "key", "some text")
  # The data matches the hash
end
```

In the case of the timed hash you may want to check if it previously matched the data. In such a case you can use the `did_match?` function:
```ruby
if Hashit.matches?(timed_hash, "key", "some text")
  # The data matches the current timed hash
elsif Hashit.did_match?(timed_hash, "key", "some text")
  # The data matched the previous timed hash
end
```

## Contributing

1. Fork it ( https://github.com/nitzanbl/hashit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
