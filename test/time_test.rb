require 'test_helper'

class TimeTest < Minitest::Test
  context "addition" do
    should "add two time units together" do
      u1 = Unit::Time.new(5, 'hr')
      u2 = Unit::Time.new(3, 'hr')
      combined_unit = u1 + u2
      assert_equal 8, combined_unit.scalar.to_f
      assert_equal 'hr', combined_unit.uom
    end

    context "error handling" do
      should "raise on adding mass to time" do
        u1 = Unit::Mass.new(5, 'mg')
        u2 = Unit::Time.new(3, 'hr')
        assert_raises ArgumentError do
          u1 + u2
        end
      end
    end
  end
  context "subtraction" do
    should "subtract one time unit from another" do
      u1 = Unit::Time.new(5, 'hr')
      u2 = Unit::Time.new(3, 'hr')
      combined_unit = u1 - u2
      assert_equal 2, combined_unit.scalar.to_f
      assert_equal 'hr', combined_unit.uom
    end

    context "error handling" do
      should "raise on subtracting a mass from a time" do
        u1 = Unit::Time.new(5, 'hr')
        u2 = Unit::Mass.new(3, 'mg')
        assert_raises ArgumentError do
          u1 - u2
        end
      end
    end
  end

  context "equality" do
    context "equivalent units" do
      should "return true" do
        u1 = Unit::Time.new(1, 'hr')
        u2 = Unit::Time.new(1, 'hr')
        assert_equal true, u1 == u2
      end
    end
    context "different scalars" do
      should "return false" do
        u1 = Unit::Time.new(2, 'hr')
        u2 = Unit::Time.new(1, 'hr')
        assert_equal false, u1 == u2
      end
    end
  end

  context "conversion" do
    #not converting between time units at this point. We only have hours. 
  end
end
