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

      should "Handle scientific notation" do
        mass = Unit.parse("5.0E-3mg")
        assert_equal true, mass.mass?
        assert_equal 0.005, mass.scalar
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

      should "Handle scientific notation" do
        vol = Unit.parse("5e2ml")
        assert_equal true, vol.volume?
        assert_equal 500, vol.scalar
        assert_equal "ml", vol.uom
      end

      should "parse a liter" do
        vol = Unit.parse("3 l")

        assert_equal true, vol.volume?
        assert_equal 3.0, vol.scalar
        assert_equal "l", vol.uom
      end
    end

    context "time" do
      should "parse a time" do
        time = Unit.parse("3 hr")

        assert_equal true, time.time?
        assert_equal 3.0, time.scalar
        assert_equal "hr", time.uom
      end

      should "parse a time without a space" do
        time = Unit.parse("3hr")

        assert_equal true, time.time?
        assert_equal 3.0, time.scalar
        assert_equal "hr", time.uom
      end

      should "parse a time with a decimal" do
        time = Unit.parse(".3hr")

        assert_equal true, time.time?
        assert_equal 0.3, time.scalar
        assert_equal "hr", time.uom
      end

    end

    context "concentration" do
      should "parse a normal concentration" do
        conc = Unit.parse("5 mg / 2 ml")

        assert_equal true, conc.concentration?
        assert_equal 2.5, conc.scalar
        assert_equal "mg/ml", conc.uom
      end

      should "parse a concentration with no scalar denominator" do
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

    context "rate" do
      should "parse a normal rate" do
        rate = Unit.parse("5 mg / 1 hr")

        assert_equal true, rate.rate?
        assert_equal 5, rate.scalar
        assert_equal "mg/hr", rate.uom
      end

      should "parse a rate with no scalar denominator" do
        rate = Unit.parse("5 mg/hr")

        assert_equal true, rate.rate?
        assert_equal 5, rate.scalar
        assert_equal "mg/hr", rate.uom
      end

      should "parse a dosage rate with no scalar denominator" do
        rate = Unit.parse("10 mg/kg/hr")

        assert_equal true, rate.rate?
        assert_equal 10, rate.scalar
        assert_equal "mg/hr", rate.uom
      end
    end

    context "solution" do
      should "parse a normal solution" do
        conc = Unit.parse("1:1000")

        assert_equal true, conc.concentration?
        assert_equal 1, conc.scalar
        assert_equal "mg/ml", conc.uom
      end
    end

    context "patch" do
      should "parse a patch object" do
        ['1 patch', '1 ptch'].each do |str|
          unit = Unit.parse(str)

          assert_equal true, unit.unit?
          assert_equal 1, unit.scalar
          assert_equal 'patch', unit.uom
        end
      end
    end

    context "unitless" do
      should "parse a unitless object" do
        ['1 ea', '1 each'].each do |str|
          unit = Unit.parse(str)

          assert_equal true, unit.unit?
          assert_equal 1, unit.scalar
          assert_equal 'ea', unit.uom
        end
      end
    end
  end
end
