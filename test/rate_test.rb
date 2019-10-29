require 'test_helper'

class Rate < Minitest::Test
  context "initialization" do
    setup do
      @denom = Unit::Time.new(1, 'hr')
    end
    should "allow mass in numerator" do
      num = Unit::Mass.new(5, 'mg')
      Unit::Rate.new(num, @denom)
    end
    should "allow unit in numerator" do
      num = Unit::Unit.new(2, 'unit')
      Unit::Rate.new(num, @denom)
    end
    should "allow volume in numerator" do
      num = Unit::Volume.new(2, 'ml')
      Unit::Rate.new(num, @denom)
    end

    should "blow up if denominator is not time" do
      num = Unit::Mass.new(5, 'mg')
      denom = Unit::Unit.new(3, 'unit')

      assert_raises Unit::IncompatibleUnitsError do
        Unit::Rate.new(num, denom)
      end
    end
  end
  context "equality" do
    context "equal" do
      context "different units" do
        context "same denom (mass)" do
          setup do
            @num1 = Unit::Mass.new(2000, 'mcg')
            @num2 = Unit::Mass.new(2, 'mg')
            denom = Unit::Time.new(1, 'hr')
            @rate1 = Unit::Rate.new(@num1, denom)
            @rate2 = Unit::Rate.new(@num2, denom)
          end

          should "be equal" do
            assert_equal @rate1, @rate2
          end
        end
        context "same denom (volume)" do
          setup do
            @num1 = Unit::Volume.new(2000, 'ml')
            @num2 = Unit::Volume.new(2, 'l')
            denom = Unit::Time.new(1, 'hr')
            @rate1 = Unit::Rate.new(@num1, denom)
            @rate2 = Unit::Rate.new(@num2, denom)
          end

          should "be equal" do
            assert_equal @rate1, @rate2
          end
        end

      end
      context "same units (mass)" do
        setup do
          @num1 = Unit::Mass.new(2, 'mg')
          @num2 = Unit::Mass.new(2, 'mg')
          denom = Unit::Time.new(1, 'hr')
          @rate1 = Unit::Rate.new(@num1, denom)
          @rate2 = Unit::Rate.new(@num2, denom)
        end

        should "be equal" do
          assert_equal @rate1, @rate2
        end
      end
      context "same units (volume)" do
        setup do
          @num1 = Unit::Volume.new(2, 'ml')
          @num2 = Unit::Volume.new(2, 'ml')
          denom = Unit::Time.new(1, 'hr')
          @rate1 = Unit::Rate.new(@num1, denom)
          @rate2 = Unit::Rate.new(@num2, denom)
        end

        should "be equal" do
          assert_equal @rate1, @rate2
        end
      end

    end
  end
  context "addition" do
    context "adding rate (mass)" do
      setup do
        @num1 = Unit::Mass.new(2, 'mg')
        @num2 = Unit::Mass.new(3, 'mg')
      end

      should "add two numbers with equivalent denominators" do
        denom = Unit::Time.new(1, 'hr')
        rate1 = Unit::Rate.new(@num1, denom)
        rate2 = Unit::Rate.new(@num2, denom)

        new_rate = rate1 + rate2

        assert_equal 5, new_rate.scalar
        assert_equal 'mg/hr', new_rate.uom
      end

      should "correctly add a smaller number" do
        denom1 = Unit::Time.new(1, 'hr')
        denom2 = Unit::Time.new(2, 'hr')
        rate1 = Unit::Rate.new(@num1, denom1)
        rate2 = Unit::Rate.new(@num2, denom2)

        new_rate = rate1 + rate2

        assert_equal 3.5, new_rate.scalar
        assert_equal 'mg/hr', new_rate.uom
      end

    end

    context "adding rate (volume)" do
      setup do
        @num1 = Unit::Volume.new(2, 'ml')
        @num2 = Unit::Volume.new(3, 'ml')
      end

      should "add two numbers with equivalent denominators" do
        denom = Unit::Time.new(1, 'hr')
        rate1 = Unit::Rate.new(@num1, denom)
        rate2 = Unit::Rate.new(@num2, denom)

        new_rate = rate1 + rate2

        assert_equal 5, new_rate.scalar
        assert_equal 'ml/hr', new_rate.uom
      end

      should "correctly add a smaller number" do
        denom1 = Unit::Time.new(1, 'hr')
        denom2 = Unit::Time.new(2, 'hr')
        rate1 = Unit::Rate.new(@num1, denom1)
        rate2 = Unit::Rate.new(@num2, denom2)

        new_rate = rate1 + rate2

        assert_equal 3.5, new_rate.scalar
        assert_equal 'ml/hr', new_rate.uom
      end

    end

    context "slows the rate (mass)" do
      setup do
        num1 = Unit::Mass.new(2, 'mg')
        denom = Unit::Time.new(1, 'hr')
        @rate = Unit::Rate.new(num1, denom)
      end

      should "return correctly" do
        slowed_rate = @rate + Unit::Time.new(1, 'hr')

        assert_equal 1, slowed_rate.scalar
        assert_equal "mg/hr", slowed_rate.uom
      end
    end

    context "slows the rate (volume)" do
      setup do
        num1 = Unit::Volume.new(2, 'ml')
        denom = Unit::Time.new(1, 'hr')
        @rate = Unit::Rate.new(num1, denom)
      end

      should "return correctly" do
        slowed_rate = @rate + Unit::Time.new(1, 'hr')

        assert_equal 1, slowed_rate.scalar
        assert_equal "ml/hr", slowed_rate.uom
      end
    end

    context "increases the rate (mass)" do
      setup do
        num1 = Unit::Mass.new(2, 'mg')
        denom = Unit::Time.new(1, 'hr')
        @rate = Unit::Rate.new(num1, denom)
      end

      should "return correctly" do
        rate = @rate + Unit::Mass.new(1, 'mg')

        assert_equal 3, rate.scalar
        assert_equal "mg/hr", rate.uom
      end
    end
    context "increases the rate (volume)" do
      setup do
        num1 = Unit::Volume.new(2, 'ml')
        denom = Unit::Time.new(1, 'hr')
        @rate = Unit::Rate.new(num1, denom)
      end

      should "return correctly" do
        rate = @rate + Unit::Volume.new(1, 'ml')

        assert_equal 3, rate.scalar
        assert_equal "ml/hr", rate.uom
      end
    end

  end

  context "subtraction" do
    setup do
      num1 = Unit::Mass.new(2, 'mg')
      num2 =  Unit::Volume.new(2, 'ml')
      denom = Unit::Time.new(1, 'hr')
      @rate = Unit::Rate.new(num1, denom)
      @mass = Unit::Mass.new(0.5, 'mg')
      @volume = Unit::Volume.new(0.5, 'ml')
      @volume_rate = Unit::Rate.new(num2, denom)
      @time = Unit::Time.new(1, 'hr')
    end

    context "rate" do
      should "subtract correctly" do
        new_rate = @rate - Unit::Rate.new(@mass, @time)

        assert_equal 1.5, new_rate.scalar
        assert_equal "mg/hr", new_rate.uom
      end
    end

    context "mass" do
      should "subtract correctly" do
        slowed_rate = @rate - @mass

        assert_equal 1.5, slowed_rate.scalar
        assert_equal "mg/hr", slowed_rate.uom
      end
    end

    context "volume" do
      should "subtract correctly" do
        slowed_rate = @volume_rate - @volume

        assert_equal 1.5, slowed_rate.scalar
        assert_equal "ml/hr", slowed_rate.uom
      end
    end

    context "time from mass rate" do
      should "subtract correctly" do
        small_time = Unit::Time.new(0.5, 'hr')
        increase = @rate - small_time
        assert_equal 4, increase.scalar
        assert_equal "mg/hr", increase.uom
      end
    end
    context "time from volume rate" do
      should "subtract correctly" do
        small_time = Unit::Time.new(0.5, 'hr')
        increase = @volume_rate - small_time
        assert_equal 4, increase.scalar
        assert_equal "ml/hr", increase.uom
      end
    end

  end

  context "multiplying" do
    setup do
      num1 = Unit::Mass.new(2, 'mg')
      num2 = Unit::Volume.new(2, 'ml')
      
      denom = Unit::Time.new(1, 'hr')
      @rate = Unit::Rate.new(num1, denom)
      @volume_rate = Unit::Rate.new(num2, denom)
    end

    context "multiplying by a mass" do
      should "raise a IncompatibleUnitsError" do
        assert_raises Unit::IncompatibleUnitsError do
          u1 = Unit::Mass.new(2, 'mg')
          @rate*u1
        end
      end
    end

    context "multiplying by a volume" do
      should "raise a IncompatibleUnitsError" do
        assert_raises Unit::IncompatibleUnitsError do
          u1 = Unit::Volume.new(2, 'ml')
          @volume_rate*u1
        end
      end
    end

    context "multiplying by an integer" do
      should "create a scaled rate" do
        rate = @rate * 2

        assert_equal true, rate.is_a?(Unit::Rate)
        assert_equal 4, rate.scalar
        assert_equal "mg/hr", rate.uom
      end
    end
  end

  context "dividing" do
    setup do
      num1 = Unit::Mass.new(2, 'mg')
      num2 = Unit::Volume.new(2, 'ml')
      
      denom = Unit::Time.new(1, 'hr')
      @rate = Unit::Rate.new(num1, denom)
      @volume_rate = Unit::Rate.new(num2, denom)
    end

    context "dividing by a mass" do
      should "raise a IncompatibleUnitsError" do
        assert_raises Unit::IncompatibleUnitsError do
          u1 = Unit::Mass.new(2, 'mg')
          @rate/u1
        end
      end
    end

    context "dividing by a mass" do
      should "raise a IncompatibleUnitsError" do
        assert_raises Unit::IncompatibleUnitsError do
          u1 = Unit::Volume.new(2, 'ml')
          @volume_rate/u1
        end
      end
    end

    context "dividing by an integer" do
      should "create a scaled rate" do
        rate = @rate / 2

        assert_equal true, rate.is_a?(Unit::Rate)
        assert_equal 1, rate.scalar
        assert_equal "mg/hr", rate.uom
      end
    end
  end

  context "conversion (mass)" do
    setup do
      num1 = Unit::Mass.new(2, 'mg')
      denom = Unit::Time.new(1, 'hr')
      @rate = Unit::Rate.new(num1, denom)
    end

    should "raise if invalid" do
      assert_raises Unit::IncompatibleUnitsError do
        @rate >> 'mg'
      end
    end

    should "convert correctly" do
      new_rate = @rate >> 'mcg/hr'
      assert_equal 2000, new_rate.scalar
      assert_equal 'mcg/hr', new_rate.uom
    end

    should "convert to unit with scalar in denomatinor" do
      new_rate = @rate >> 'mg/2hr'
      assert_equal 1, new_rate.scalar
      assert_equal 'mg/hr', new_rate.uom
    end
  end

  context "conversion (volume)" do
    setup do
      num1 = Unit::Volume.new(2, 'l')
      denom = Unit::Time.new(1, 'hr')
      @rate = Unit::Rate.new(num1, denom)
    end

    should "raise if invalid" do
      assert_raises Unit::IncompatibleUnitsError do
        @rate >> 'ml'
      end
    end

    should "convert correctly" do
      new_rate = @rate >> 'ml/hr'
      assert_equal 2000, new_rate.scalar
      assert_equal 'ml/hr', new_rate.uom
    end

    should "convert to unit with scalar in denomatinor" do
      new_rate = @rate >> 'l/2hr'
      assert_equal 1, new_rate.scalar
      assert_equal 'l/hr', new_rate.uom
    end
  end

  context "abs" do
    setup do
      num1 = Unit::Mass.new(-2, 'mg')
      denom = Unit::Time.new(1, 'hr')
      @rate = Unit::Rate.new(num1, denom)
    end

    should "return a new rate with abs scalar" do
      assert_equal 2, @rate.abs.scalar
    end
  end

  context "#equivalise" do
    [
      ['1 mcg/hr', '1 mg/hr', '1 mcg/hr', '1000 mcg/hr'],
      ['1 ml/hr', '1 l/hr', '1 ml/hr', '1000 ml/hr']
    ].each do |u1, u2, expected_1, expected_2|
      should "equivalise #{u1} and #{u2}" do

      end
    end
  end

  context "hash" do
    setup do
      num = Unit::Mass.new(2, 'mg')
      denom = Unit::Time.new(1, 'hr')
      @rate1 = Unit::Rate.new(num, denom)
      @rate2 = Unit::Rate.new(num, denom)
    end

    should "correctly hash instances with the same attributes" do
      assert_equal @rate1.hash, @rate2.hash
    end
  end

  context "eql" do
    setup do
      num1 = Unit::Mass.new(2, 'mg')
      num2 = Unit::Mass.new('.02', 'mcg')
      denom = Unit::Time.new(1, 'hr')
      @rate1 = Unit::Rate.new(num1, denom)
      @rate2 = Unit::Rate.new(num2, denom)
    end

    should "correctly compare equivalent rates" do
      @rate1.eql?(@rate2)
    end
  end
  context "eql (volume)" do
    setup do
      num1 = Unit::Volume.new(2, 'l')
      num2 = Unit::Volume.new('.02', 'ml')
      denom = Unit::Time.new(1, 'hr')
      @rate1 = Unit::Rate.new(num1, denom)
      @rate2 = Unit::Rate.new(num2, denom)
    end

    should "correctly compare equivalent rates" do
      @rate1.eql?(@rate2)
    end
  end

end
