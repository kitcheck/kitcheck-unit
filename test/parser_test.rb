require 'test_helper'

class ParserTest < Minitest::Test
  context "#parse" do

    context "errors" do
      should "Throw an error with weird slash" do
        assert_raises Unit::IncompatibleUnitsError do
          Unit.parse("5 mg /")
        end
      end

      should "throw an error with invalid symbol" do
        assert_raises Unit::IncompatibleUnitsError do
          Unit.parse("@ 5 mg")
        end
      end

      should "raise on invalid unit" do
        assert_raises Unit::IncompatibleUnitsError do
          Unit.parse("5 mcL")
        end
      end

      should "not parse a poorly constructed concentration" do
        assert_raises Unit::IncompatibleUnitsError do
          Unit.parse("5 mg $/ 2 ml")
        end
      end
    end

    context "mass" do
      should "parse a normal mass" do
        mass = Unit.parse('5 mg')

        assert_equal true, mass.mass?
        assert_equal 5.0, mass.scalar
        assert_equal "mg", mass.uom
      end

      should "Handle capitalization" do
        mass = Unit.parse("5 Mg")
        assert_equal true, mass.mass?
        assert_equal 5.0, mass.scalar
        assert_equal "mg", mass.uom
      end

      should "parse gm" do
        mass = Unit.parse('5 gm')

        assert_equal true, mass.mass?
        assert_equal 5.0, mass.scalar
        assert_equal "g", mass.uom
      end
    end

    context "volume" do
      should "parse a volume" do
        vol = Unit.parse("3 ml")

        assert_equal true, vol.volume?
        assert_equal 3.0, vol.scalar
        assert_equal "ml", vol.uom
      end

      should "parse a liter" do
        vol = Unit.parse("3 l")

        assert_equal true, vol.volume?
        assert_equal 3.0, vol.scalar
        assert_equal "l", vol.uom
      end
    end

    context "concentration" do
      should "parse a normal concentration" do
        conc = Unit.parse("5 mg / 2 ml")

        assert_equal true, conc.concentration?
        assert_equal 2.5, conc.scalar
        assert_equal "mg/ml", conc.uom
      end

      should "parse a concentration with no scalar denominator qqq" do
        conc = Unit.parse("5 mg/ml")

        assert_equal true, conc.concentration?
        assert_equal 5, conc.scalar
        assert_equal "mg/ml", conc.uom
      end

      should "parse a %" do
        conc = Unit.parse('5 %')

        assert_equal true, conc.concentration?
        assert_equal 50, conc.scalar
        assert_equal "mg/ml", conc.uom
      end
    end
  end
end
