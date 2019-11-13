class Unit::Parser
token SCALAR MASS_UOM VOLUME_UOM TIME_UOM PATCH_UOM UNIT_UOM UNITLESS_UOM EQUIVALENCE_UOM PERCENT SLASH COLON
rule
  valid_unit:
    concentration |
    concentration_no_denom_scalar |
    unit_concentration |
    unit_concentration_no_denom_scalar |
    unit_less_concentration |
    unit_less_concentration_no_denom_scalar |
    rate |
    rate_no_denom_scalar |
    volume_rate |
    volume_rate_no_denom_scalar |
    equivalence_concentration |
    equivalence_concentration_no_denom_scalar |
    rational_concentration |
    mass |
    volume |
    time |
    unit |
    unitless |
    patch |
    equivalence |
    percent |
    solution

  concentration : mass SLASH volume { return Concentration.new(val[0], val[2]) }
  concentration_no_denom_scalar : mass SLASH VOLUME_UOM { return Concentration.new(val[0], Volume.new(1, val[2])) }
  rational_concentration : SCALAR SLASH SCALAR MASS_UOM SLASH VOLUME_UOM { return Concentration.new(Mass.new(val[0], val[3]), Volume.new(val[2], val[5])) }

  unit_concentration : unit SLASH volume { return Concentration.new(val[0], val[2]) }
  unit_concentration_no_denom_scalar : unit SLASH VOLUME_UOM { return Concentration.new(val[0], Volume.new(1, val[2])) }

  equivalence_concentration : equivalence SLASH volume { return Concentration.new(val[0], val[2]) }
  equivalence_concentration_no_denom_scalar : equivalence SLASH VOLUME_UOM { return Concentration.new(val[0], Volume.new(1, val[2])) }

  unit_less_concentration : unitless SLASH volume { return Concentration.new(val[0], val[2]) }
  unit_less_concentration_no_denom_scalar : unitless SLASH VOLUME_UOM { return Concentration.new(val[0], val[2]) }

  rate : mass SLASH time { return Rate.new(val[0], val[2])}
  rate_no_denom_scalar : mass SLASH TIME_UOM { return Rate.new(val[0], Time.new(1, val[2])) }

  volume_rate : volume SLASH time { return Rate.new(val[0], val[2])}
  volume_rate_no_denom_scalar : volume SLASH TIME_UOM { return Rate.new(val[0], Time.new(1, val[2])) }

  mass : SCALAR MASS_UOM { return Mass.new(val[0], val[1]) }

  volume : SCALAR VOLUME_UOM { return Volume.new(val[0], val[1]) }

  time : SCALAR TIME_UOM { return Time.new(val[0], val[1]) }

  patch : SCALAR PATCH_UOM { return Unit.new(val[0], 'patch') }

  unit : SCALAR UNIT_UOM { return Unit.new(val[0], 'unit') }

  unitless : SCALAR UNITLESS_UOM { return Unit.new(val[0], val[1]) }

  percent : SCALAR PERCENT { return Concentration.new(Mass.new(val[0] * 10, 'mg'), Volume.new(1, 'ml')) }

  equivalence : SCALAR EQUIVALENCE_UOM { return Equivalence.new(val[0], val[1]) }

  solution : SCALAR COLON SCALAR { return Concentration.new(Mass.new(val[0] * 1000, 'mg'), Volume.new(val[2], 'ml')) }


end

---- header
  require_relative 'lexer'

---- inner
  def parse(input)
    #Takes the results from the lexer's tokenize method and returns stuff
    @tokens = input
    do_parse
  end

  def next_token
    @tokens.shift
  end
