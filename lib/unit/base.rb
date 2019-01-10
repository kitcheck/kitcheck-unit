module Unit
  class Base
    include Comparable
    include Formatter

    attr_reader :scalar, :uom, :components

    def initialize(scalar, uom, components = [])
      @scalar = BigDecimal(scalar, 10)
      @uom = validate_uom(uom)
      @components = [components].compact.flatten
    end

    def self.scale_hash
      {}
    end

    def scale_hash
      self.class.scale_hash
    end

    def hash
      scalar.hash ^ uom.hash
    end

    def validate_uom(uom)
      if self.scale_hash.keys.include? uom
        uom
      else
        raise IncompatibleUnitsError.new("This unit is incompatible (#{uom})")
      end
    end

    def +(other)
      if @uom == other.uom
        self.class.new((scalar + other.scalar), @uom, @components + other.components)
      else
        use_operator_on_other(:+, other)
      end
    end

    def -(other)
      if @uom == other.uom
        self.class.new((@scalar - other.scalar), @uom, @components + other.components)
      else
        use_operator_on_other(:-, other)
      end
    end

    def *(other)
      if other.is_a?(Numeric)
        self.scale(other)
      else
        raise IncompatibleUnitsError.new("These units are incompatible (#{self.to_s} and #{other.to_s})")
      end
    end

    def /(other)
      if other.is_a? self.class
        if @uom == other.uom
          @scalar / other.scalar
        else
          u1, u2 = self.class.equivalise(self, other)
          u1.scalar / u2.scalar
        end
      elsif other.is_a?(Numeric)
        self.scale(1.0/other)
      else
        raise "Implement in subclasses"
      end
    end

    alias_method :add, :+
    alias_method :subtract, :-
    alias_method :divide, :/

    def scale(scale)
      if scale.is_a? Float
        scale = BigDecimal.new(scale, 10)
      end
      self.class.new(@scalar * scale, @uom, @components)
    end

    def <=>(other)
      if self.class == other.class
        comp_hash = self.scale_hash
        order_of_mag_comp = comp_hash[self.uom] <=> comp_hash[other.uom]
        if order_of_mag_comp == -1
          self <=> other.convert_to(self.uom)
        elsif order_of_mag_comp == 0
          self.scalar <=> other.scalar
        elsif order_of_mag_comp == 1
          self.convert_to(other.uom) <=> other
        end
      else
        nil
      end
    end

    def convert_to(uom)
      #Validate unit
      if self.uom == uom
        return self
      end
      destination_exp = self.scale_hash[uom]
      if destination_exp
        source_exp = self.scale_hash[@uom]
        #Get difference in exponents
        exp_diff = source_exp - destination_exp
        scaled_amount = @scalar * BigDecimal.new((10**exp_diff), 10)
        #Return new unit
        self.class.new(scaled_amount, uom, @components)
      else
        raise IncompatibleUnitsError.new("This unit is incompatible (#{uom})")
      end
    end
    alias_method :>>, :convert_to

    def abs
      self.class.new(self.scalar.abs, self.uom)
    end

    def eql?(other)
      (self <=> other) == 0
    end

    def mass?
      Mass.scale_hash.keys.include? self.uom
    end

    def volume?
      Volume.scale_hash.keys.include? self.uom
    end

    def unit?
      Unit.scale_hash.keys.include? self.uom
    end

    def self.equivalise(u1, u2)
      raise IncompatibleUnitsError.new("These units are incompatible (#{u1.uom} and #{u2.uom})") unless u1.class == u2.class
      comp_hash = u1.scale_hash
      order_of_mag_comp = comp_hash[u1.uom] <=> comp_hash[u2.uom]
      if order_of_mag_comp == -1
        return u1, u2.convert_to(u1.uom)
      elsif order_of_mag_comp == 0
        return u1, u2
      elsif order_of_mag_comp == 1
        return u1.convert_to(u2.uom), u2
      end
    end

    def concentration?
      false
    end

    def inspect
      to_s
    end

    private

    def use_operator_on_other(operator, other)
      if self < other
        scaled_other = other.convert_to(self.uom)
        self.class.new((@scalar.send(operator, scaled_other.scalar)), scaled_other.uom, @components + other.components)
      else
        scaled_self = self.convert_to(other.uom)
        self.class.new((scaled_self.scalar.send(operator, other.scalar)), scaled_self.uom, @components + other.components)
      end
    end
  end
end
