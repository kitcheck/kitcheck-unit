module Unit
  class Time < Base

    def self.scale_hash
      {
        'min' => 0,
        'hr' => 1
      }
    end

    def convert_to(uom)
      if !self.class.scale_hash.keys.include?(uom)
        raise IncompatibleUnitsError.new("This unit is incompatible (#{uom})")
      end

      return self if self.uom == uom

      if self.uom == 'min' && uom == 'hr'
        scaled_amount = @scalar / 60
        self.class.new(scaled_amount, uom, @components)
      elsif self.uom == 'hr' && uom == 'min'
        scaled_amount = @scalar * 60
        self.class.new(scaled_amount, uom, @components)
      end
    end
    alias_method :>>, :convert_to
  end
end
