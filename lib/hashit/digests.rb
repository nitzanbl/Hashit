require 'openssl'
require 'date'
require 'hashit/prepare'

module Hashit
  class << self
    %w[md2 md4 md5 sha sha1 sha224 sha256 sha384 sha512].each do |type|
      define_method(type.to_sym) do |key, text|
        "#{type}|" + generate_hash(OpenSSL::Digest.const_get(type.upcase.to_sym).new, key, text)
      end

      define_method("timed_#{type}".to_sym) do |key, text|
        key = ([] << key).flatten << current_time
        "timed_#{type}|" + generate_hash(OpenSSL::Digest.const_get(type.upcase.to_sym).new, key, text)
      end

      define_method("previous_#{type}".to_sym) do |key, text|
        key = ([] << key).flatten << last_time
        "timed_#{type}|" + generate_hash(OpenSSL::Digest.const_get(type.upcase.to_sym).new, key, text)
      end
    end

    def current_time
      d = DateTime.now
      ts = d.strftime("%s").to_i
      ts - ((d.minute % 30) * 60) - d.second
    end

    def last_time
      current_time - (30 * 60)
    end

    def generate_hash digest, key, text
      text = Hashit.prepare text

      if key.is_a? Array
        key.reduce(text) do |text, k|
          k = Hashit.prepare k
          OpenSSL::HMAC.hexdigest(digest, k, text)
        end
      else
        key = Hashit.prepare key
        OpenSSL::HMAC.hexdigest(digest, key, text)
      end
    end
  end
end
