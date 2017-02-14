require 'test_helper'

class UnitTest < Minitest::Test
  
  context "same unit and strength" do
    setup do
      @u1 = Unit::Unit.new(1, 'ea')
      @u2 = Unit::Unit.new(1, 'ea')
    end

    should "be equal" do
      assert @u1.eql? @u2
    end

    should "be grouped together in group_by" do
      array = [{
        :item => 'item1', :package_size => @u1},
        {:item => 'item2', :package_size => @u2}
      ]

      assert_equal 1, array.group_by{|i| i[:package_size]}.size
    end
  end

  context "different but compatible units" do
    setup do
      @u1 = Unit.parse('100 mcg')
      @u2 = Unit.parse('0.1 mg')
    end

    should "be equal" do
      assert @u1.eql? @u2
    end
  end

  context "different units" do
    setup do
      @u1 = Unit::Unit.new(1, 'ea')
      @u2 = Unit::Unit.new(1, 'unit')
    end

    should "not allow you to operate on two unitless objects of different uom" do
      [:+, :-, :/, :<].each do |operation|
        assert_raises Unit::IncompatibleUnitsError do
          @u1.send(operation, @u2)
        end
      end
    end

    should "raise if trying to multiply two units" do
      assert_raises Unit::IncompatibleUnitsError do
        @u1 * @u2
      end
    end

    should "raise if trying to divide two units" do
      assert_raises Unit::IncompatibleUnitsError do
        @u1 / @u2
      end
    end

    should "return false when comparing against nil" do
      assert_equal false, @u1 == nil
    end
  end

  context "multiplying" do
    context "multiplying by a unit" do
      should "raise a IncompatibleUnitsError" do
        assert_raises Unit::IncompatibleUnitsError do
          u1 = Unit::Unit.new(4, 'unit')
          u2 = Unit::Unit.new(4, 'unit')
          u1*u2
        end
      end
    end

    context "multiplying by an integer" do
      should "create a scaled unit" do
        u1 = Unit::Unit.new(4, 'unit')
        unit = u1 * 2

        assert_equal true, unit.is_a?(Unit::Unit)
        assert_equal 8, unit.scalar
        assert_equal "unit", unit.uom
      end
    end
  end

  context "division" do
    context "dividing by volume" do
      should "create a concentration" do
        u1 = Unit::Unit.new(10, 'unit')
        u2 = Unit::Volume.new(1, 'ml')
        conc = u1/u2

        assert_equal true, conc.concentration?
        assert_equal 10, conc.scalar
        assert_equal "unit/ml", conc.uom
      end
    end
  end

  context "conversion" do
    context "to another unit" do
      should "blow up" do
        u1 = Unit::Unit.new(10, 'unit')
        assert_raises Unit::IncompatibleUnitsError do
          u1 >> 'meq'
        end
      end
    end
  end
end
