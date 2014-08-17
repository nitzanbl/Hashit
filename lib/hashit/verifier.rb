require 'hashit/digests'

module Hashit
  class << self
    def matches? hash, key, text
      type = hash.split('|').first
      raise ArgumentError, "invalid hash" unless Hashit.respond_to?(type.to_sym)
      new_hash = Hashit.send type.to_sym, key, text
      new_hash == hash
    end

    def did_match? hash, key, text
      type = hash.split('|').first.sub("timed", "previous")
      raise ArgumentError, "invalid hash" unless Hashit.respond_to?(type.to_sym)
      new_hash = Hashit.send type.to_sym, key, text
      new_hash == hash
    end
  end
end
