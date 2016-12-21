module Unit
  class Unit < Base

    def self.scale_hash
      {
        'unit' => 0,
        'ea' => 0
      }
    end

    #We need to make sure we can't add different unitless objects together

    def +(other)
      check_compatibility("add", other)
      super(other)
    end

    def -(other)
      check_compatibility("subtract", other)
      super(other)
    end

    def /(other)
      check_compatibility("divide", other)
      if other.is_a?(Volume)
        Concentration.new(self, other)
      else
        super(other)
      end
    end

    def <=>(other)
      check_compatibility("compare", other)
      super(other)
    end

    def convert_to(uom)
      if self.uom != uom
        raise_incompatible_error("compare")
      end
      super(uom)
    end
    alias_method :>>, :convert_to

    def self.equivalise(u1, u2)
      if u1.uom != u2.uom && other.is_a?(Unit)
        raise_incompatible_error("compare")
      end
      super(u1, u2)
    end

    private

    def check_compatibility(operation, other)
      if other && (self.uom != other.uom && other.is_a?(Unit))
        raise_incompatible_error(operation)
      end
    end

    def raise_incompatible_error(operation)
      raise IncompatibleUnitsError.new("You cannot #{operation} two different unitless units together")
    end
  end
end
