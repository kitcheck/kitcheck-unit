module Unit
  class Unit < Base

    def self.scale_hash
      {
        'unit' => 0,
        'ea' => 0,
        'meq' => 0
      }
    end

    #We need to make sure we can't add different unitless objects together

    def +(other)
      if self.uom != other.uom
        raise IncompatibleUnitsError.new("You cannot add two different unitless units together")
      end
      super(other)
    end

    def -(other)
      if self.uom != other.uom
        raise IncompatibleUnitsError.new("You cannot subtract two different unitless units together")
      end
      super(other)
    end

    def /(other)
      if self.uom != other.uom
        raise IncompatibleUnitsError.new("You cannot divide two different unitless units together")
      end
      super(other)
    end

    def <=>(other)
      if self.uom != other.uom
        raise IncompatibleUnitsError.new("You cannot compare two different unitless units together")
      end
      super(other)
    end

    def convert_to(uom)
      if self.uom != other.uom
        raise IncompatibleUnitsError.new("You cannot compare two different unitless units together")
      end
      super(other)
    end

    def self.equivalise(u1, u2)
      if u1.uom != u2.uom
        raise IncompatibleUnitsError.new("You cannot compare two different unitless units together")
      end
      super(u1, u2)
    end
  end
end
