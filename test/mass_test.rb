require 'test_helper'

class MassTest < Minitest::Test
  context "addition" do
    should "add two masses together" do
      u1 = Unit::Mass.new(5, 'mg')
      u2 = Unit::Mass.new(3, 'mg')
      combined_unit = u1 + u2
      assert_equal 8, combined_unit.scalar.to_f
      assert_equal 'mg', combined_unit.uom
    end

    should "convert to smallest unit and add" do
      u1 = Unit::Mass.new(5, 'mg')
      u2 = Unit::Mass.new(3, 'mcg')
      combined_unit = u1 + u2
      assert_equal 5003, combined_unit.scalar.to_f
      assert_equal 'mcg', combined_unit.uom
    end

    context "error handling" do
      should "raise on adding volume to mass" do
        u1 = Unit::Mass.new(5, 'mg')
        u2 = Unit::Volume.new(3, 'ml')
        assert_raises Unit::IncompatibleUnitsError do
          u1 + u2
        end
      end
    end
  end
  context "subtraction" do
    should "subtract one mass from another" do
      u1 = Unit::Mass.new(5, 'mg')
      u2 = Unit::Mass.new(3, 'mg')
      combined_unit = u1 - u2
      assert_equal 2, combined_unit.scalar.to_f
      assert_equal 'mg', combined_unit.uom
    end

    should "conver to smallest unit and subtract" do
      u1 = Unit::Mass.new(5, 'mg')
      u2 = Unit::Mass.new(3, 'mcg')
      combined_unit = u1 - u2
      assert_equal 4997, combined_unit.scalar.to_f
      assert_equal 'mcg', combined_unit.uom
    end

    context "error handling" do
      should "raise on subtracting a volume from a mass" do
        u1 = Unit::Mass.new(5, 'mg')
        u2 = Unit::Volume.new(3, 'ml')
        assert_raises Unit::IncompatibleUnitsError do
          u1 - u2
        end
      end
    end
  end

  context "equality" do
    context "equivalent units" do
      should "return true" do
        u1 = Unit::Mass.new(1, 'mg')
        u2 = Unit::Mass.new(1, 'mg')
        assert_equal true, u1 == u2
      end
    end
    context "different scalars" do
      should "return false" do
        u1 = Unit::Mass.new(2, 'mg')
        u2 = Unit::Mass.new(1, 'mg')
        assert_equal false, u1 == u2
      end
    end
    context "different uom" do
      context "inequivalent amounts" do
        should "return false" do
          u1 = Unit::Mass.new(1, 'mcg')
          u2 = Unit::Mass.new(1, 'mg')
          assert_equal false, u1 == u2
        end
      end

      context "equivalent amounts" do
        should "return true" do
          u1 = Unit::Mass.new(1000, 'mcg')
          u2 = Unit::Mass.new(1, 'mg')
          assert_equal true, u1 == u2
        end
      end
    end
  end

  context "dividing" do
    context "dividing by mass" do
      should "return divided scalers" do
        u1 = Unit::Mass.new(1, 'mg')
        u2 = Unit::Mass.new(2, 'mg')
        assert_equal '0.5 mg', (u1/u2).to_s
      end
    end
    context "dividing by volume" do
      should "create a concentration" do
        u1 = Unit::Mass.new(3, 'mg')
        u2 = Unit::Volume.new(1, 'ml')
        conc = u1/u2

        assert_equal true, conc.is_a?(Unit::Concentration)
        assert_equal 3, conc.calculated_scalar
        assert_equal "mg/ml", conc.calculated_uom
      end
    end
  end

  context "comparison" do
    context "a == b" do
      context "same unit" do
        should "return 0" do
          a = Unit::Mass.new(1, 'mg')
          b = Unit::Mass.new(1, 'mg')
          assert_equal 0, a <=> b
        end
      end

      context "equivalent unit" do
        should "return 0" do
          a = Unit::Mass.new(1, 'mg')
          b = Unit::Mass.new(1000, 'mcg')
          assert_equal 0, a <=> b
        end
      end
    end

    context "a < b" do
      context "same units" do
        should "return -1" do
          a = Unit::Mass.new(1, 'mg')
          b = Unit::Mass.new(2, 'mg')
          assert_equal (-1), a <=> b
        end
      end

      context "different units" do
        should "return -1" do
          a = Unit::Mass.new(1, 'mcg')
          b = Unit::Mass.new(1, 'mg')
          assert_equal (-1), a <=> b
        end
      end
    end

    context "a > b" do
      context "same units" do
        should "return 1" do
          a = Unit::Mass.new(2, 'mg')
          b = Unit::Mass.new(1, 'mg')
          assert_equal 1, a <=> b
        end
      end

      context "different units" do
        should "return 1" do
          a = Unit::Mass.new(1, 'mg')
          b = Unit::Mass.new(1, 'mcg')
          assert_equal 1, a <=> b
        end
      end
    end
  end
end
