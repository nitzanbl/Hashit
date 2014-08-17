module Hashit
  class << self
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
  end
end
