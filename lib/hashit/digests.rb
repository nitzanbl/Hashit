require 'openssl'
require 'date'
require 'hashit/prepare'

module Hashit
  module Digests
    HASHING_DIGESTS = %w[md2 md4 md5 sha sha1 sha224 sha256 sha384 sha512]

    HASHING_DIGESTS.each.with_index do |type, i|
      define_method(type.to_sym) do |key, text|
        "r#{i}|" + generate_hash(OpenSSL::Digest.const_get(type.upcase.to_sym).new, key, text)
      end

      define_method("timed_#{type}".to_sym) do |key, text|
        key = ([] << key).flatten << current_time
        "t#{i}|" + generate_hash(OpenSSL::Digest.const_get(type.upcase.to_sym).new, key, text)
      end

      define_method("previous_#{type}".to_sym) do |key, text|
        key = ([] << key).flatten << last_time
        "t#{i}|" + generate_hash(OpenSSL::Digest.const_get(type.upcase.to_sym).new, key, text)
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
      text = prepare text

      if key.is_a? Array
        key.reduce(text) do |text, k|
          k = prepare k
          OpenSSL::HMAC.hexdigest(digest, k, text)
        end
      else
        key = Hashit.prepare key
        OpenSSL::HMAC.hexdigest(digest, key, text)
      end
    end

    def prepare obj
      return obj if obj.is_a? String

      if obj.is_a? Array
        obj = prepare_array obj
      elsif obj.nil?
        raise ArgumentError, "Nil passed in as a text parameter"
      elsif obj.respond_to? :to_s
          obj = obj.to_s
      else
        raise ArgumentError, "Parameter #{obj} cannot be converted to string"
      end

      obj
    end

    def prepare_array arr
      arr.reduce("") do |str, el|
        str += prepare el
      end
    end

    def matches? hash, key, text
      type = get_hash_type hash.split('|').first
      raise ArgumentError, "invalid hash" if type.nil? || !Hashit.respond_to?(type)
      new_hash = Hashit.send type, key, text
      new_hash == hash
    end

    def did_match? hash, key, text
      type = get_hash_type hash.split('|').first
      fn = type.to_s.sub("timed", "previous").to_sym
      raise ArgumentError, "invalid hash" if type.nil? || !Hashit.respond_to?(fn)
      new_hash = Hashit.send fn, key, text
      new_hash == hash
    end

    private
      def get_hash_type segment
        i = segment[1..-1].to_i
        return nil if segment[1..-1] != i.to_s
        type = HASHING_DIGESTS[i]
        type = "timed_#{type}" if segment[0] == 't'
        type.to_sym
      end
  end
end
