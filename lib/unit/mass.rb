module Unit
  class Mass < Base

    def /(other)
      if other.is_a? Mass
        super(other)
      elsif other.is_a? Numeric
        super(other)
      elsif other.is_a? Volume
        Concentration.new(self, other)
      elsif other.is_a? Time
        Rate.new(self, other)
      else
        raise IncompatibleUnitsError.new("These units are incompatible (#{self.to_s} and #{other.to_s})")
      end
    end

    #Maps a unit of measure to it's power of 10 exponent, relative to mg
    def self.scale_hash
      {
        'mcg' => -3,
        'mg' => 0,
        'g' => 3
      }
    end
  end
end
