module Unit
  class Rate
    include Comparable
    include Formatter

    attr_reader :numerator, :denominator, :scalar, :uom, :components

    def initialize(numerator, denominator)
      @numerator = numerator#Top of line
      @denominator = denominator #Bottom of line
      @components = []
      if !(numerator.is_a?(Mass) || numerator.is_a?(Volume) || numerator.is_a?(Unit) || numerator.is_a?(Equivalence)) || !denominator.is_a?(Time)
        raise IncompatibleUnitsError.new("The numerator must be a mass and the denominator must be a time")
      end
    end

    def hash
      numerator.hash ^ denominator.hash
    end

    def eql?(other)
      rate1, rate2 = Rate.equivalise(self, other)
      rate1 == rate2
    end

    def +(other)
      use_operator_on_other(:+, other)
    end

    def -(other)
      use_operator_on_other(:-, other)
    end

    def *(other)
      if other.is_a?(Numeric)
        Rate.new(
          numerator * other,
          denominator
        )
      else
        raise IncompatibleUnitsError.new("These units are incompatible (#{self.to_s} and #{other.to_s})")
      end
    end

    def /(other)
      if other.respond_to?(:rate?) && other.rate?
        rate1, rate2 = Rate.equivalise(self, other)
        rate1.scalar / rate2.scalar
      elsif other.is_a? Numeric
        Rate.new(
          numerator / other,
          denominator
        )
      else
        raise IncompatibleUnitsError
      end
    end

    def convert_to(uom)
      uoms = uom.split("/")
      if uoms.size  <= 1
        raise IncompatibleUnitsError
      end
      tokens = Lexer.new.tokenize("1 #{uom}")
      destination_rate = Parser.new.parse(tokens)
      Rate.new(
        numerator.convert_to(destination_rate.numerator.uom).scale(destination_rate.scalar),
        denominator.convert_to(destination_rate.denominator.uom)
      )
    end
    alias_method :>>, :convert_to

    def abs
      Rate.new(numerator.abs, denominator.abs)
    end

    def <=>(other)
      if self.class == other.class
        rate1, rate2 = Rate.equivalise(self, other)
        rate1.numerator <=> rate2.numerator
      else
        nil
      end
    end

    def scalar
      @numerator.scalar / @denominator.scalar
    end

    def uom
      @numerator.uom + "/" + @denominator.uom
    end

    def concentration?
      false
    end

    def mass?
      false
    end

    def volume?
      false
    end

    def time?
      false
    end

    def rate?
      true
    end

    def unit?
      false
    end

    private

    def use_operator_on_other(operator, other)

      if other.is_a? Rate
        #Add numerators
        rate1, rate2 = Rate.equivalise(self, other)
        Rate.new(rate1.numerator.send(operator, rate2.numerator),
                          rate1.denominator #This is the same for both rates because of the equivalise method
                         )
      elsif other.is_a? Time
        Rate.new(self.numerator, self.denominator.send(operator, other))
      elsif other.is_a? Mass
        Rate.new(self.numerator.send(operator, other), self.denominator)
      elsif other.is_a? Volume
        Rate.new(self.numerator.send(operator, other), self.denominator)
      end
    end

    def self.equivalise(rate1, rate2)
      #if equivalent denoms, don't need to convert
      if rate1.denominator == rate2.denominator
        return rate1, rate2
      end
      #convert_denominator 
      if rate1.denominator.class == rate2.denominator.class
        converted_denom1, converted_denom2 = Time.equivalise(rate1.denominator, rate2.denominator)
        combined_denom = converted_denom1.class.new(converted_denom1.scalar * converted_denom2.scalar,
                                                    converted_denom1.uom,
                                                    converted_denom1.components + converted_denom2.components) #multiply denominators by each other
        #cross multiply
        scaled_num1 = rate1.numerator.scale(converted_denom2.scalar)
        scaled_num2 = rate2.numerator.scale(converted_denom1.scalar)
        new_rate1 = Rate.new(scaled_num1, combined_denom)
        new_rate2 = Rate.new(scaled_num2, combined_denom)
        return new_rate1, new_rate2
      else
        raise IncompatibleUnitsError
      end
    end


  end
end
