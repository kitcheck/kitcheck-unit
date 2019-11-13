module Unit
  class Concentration
    include Comparable
    include Formatter

    attr_reader :numerator, :denominator, :scalar, :uom, :components

    def initialize(numerator, denominator)
      @numerator = numerator#Top of line
      @denominator = denominator #Bottom of line
      @components = []

      if !(numerator.is_a?(Mass) || numerator.is_a?(Unit) || numerator.is_a?(Equivalence)) || !denominator.is_a?(Volume)
        raise IncompatibleUnitsError.new("The numerator must be a mass and the denominator must be a volume")
      end
    end

    def hash
      numerator.hash ^ denominator.hash
    end

    def eql?(other)
      con1, con2 = Concentration.equivalise(self, other)
      con1 == con2
    end

    def +(other)
      use_operator_on_other(:+, other)
    end

    def -(other)
      use_operator_on_other(:-, other)
    end

    def *(other)
      if other.is_a?(Numeric)
        Concentration.new(
          numerator * other,
          denominator
        )
      else
        raise IncompatibleUnitsError.new("These units are incompatible (#{self.to_s} and #{other.to_s})")
      end
    end

    def /(other)
      if other.respond_to?(:concentration?) && other.concentration?
        con1, con2 = Concentration.equivalise(self, other)
        con1.scalar / con2.scalar
      elsif other.is_a? Numeric
        Concentration.new(
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
      destination_conc = Parser.new.parse(tokens)
      Concentration.new(
        numerator.convert_to(destination_conc.numerator.uom).scale(destination_conc.scalar),
        denominator.convert_to(destination_conc.denominator.uom)
      )
    end
    alias_method :>>, :convert_to

    def abs
      Concentration.new(numerator.abs, denominator.abs)
    end

    def <=>(other)
      if self.class == other.class
        con1, con2 = Concentration.equivalise(self, other)
        con1.numerator <=> con2.numerator
      else
        nil
      end
    end

    def mass_from_volume(volume)
      raise ArgumentError.new("Argument must be a volume") unless volume.volume?
      volume = volume.convert_to(denominator.uom)
      numerator.class.new(scalar, numerator.uom).scale(volume.scalar)
    end

    def volume_from_mass(mass)
      raise ArgumentError.new("Argument must be a mass") unless mass.mass?
      mass = mass.convert_to(numerator.uom)
      denominator.scale(mass / numerator)
    end

    def scalar
      @numerator.scalar / @denominator.scalar
    end

    def uom
      @numerator.uom + "/" + @denominator.uom
    end

    def concentration?
      true
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
      false
    end

    def unit?
      false
    end

    private

    def use_operator_on_other(operator, other)
      if other.is_a? Concentration
        #Add numerators
        con1, con2 = Concentration.equivalise(self, other)
        Concentration.new(con1.numerator.send(operator, con2.numerator),
                          con1.denominator #This is the same for both cons because of the equivalise method
                         )
      elsif other.is_a? Mass
        Concentration.new(self.numerator.send(operator, other), self.denominator)
      elsif other.is_a? Volume
        #Making the assumption that you're diluting
        Concentration.new(self.numerator, self.denominator.send(operator, other))
      end
    end

    def self.equivalise(con1, con2)
      #if equivalent denoms, don't need to convert
      if con1.denominator == con2.denominator
        return con1, con2
      end
      #convert_denominator
      if con1.denominator.class == con2.denominator.class
        converted_denom1, converted_denom2 = Volume.equivalise(con1.denominator, con2.denominator)
        combined_denom = converted_denom1.class.new(converted_denom1.scalar * converted_denom2.scalar,
                                                    converted_denom1.uom,
                                                    converted_denom1.components + converted_denom2.components) #multiply denominators by each other
        #cross multiply
        scaled_num1 = con1.numerator.scale(converted_denom2.scalar)
        scaled_num2 = con2.numerator.scale(converted_denom1.scalar)
        new_con1 = Concentration.new(scaled_num1, combined_denom)
        new_con2 = Concentration.new(scaled_num2, combined_denom)

        return new_con1, new_con2
      else
        raise IncompatibleUnitsError
      end
    end
  end
end
