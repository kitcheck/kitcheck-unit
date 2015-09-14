class Unit::Lexer
option
  ignorecase
macro
  BLANK       [\ \t]+
  SCALAR      [-+]?[0-9]*\.?[0-9]+
  MASS_UOM    \b(?:mcg|mg|g)\b
  VOLUME_UOM  \b(?:ml)\b
  UNIT_UOM    \b(?:unit|ea)\b
rule
  {BLANK}
  {SCALAR}      { [:SCALAR, BigDecimal.new(text, 10)] }

  #Mass
  \b(?:gm)\b    { [:MASS_UOM, 'g'] }
  {MASS_UOM}    { [:MASS_UOM, text] }

  #Volume
  {VOLUME_UOM}  { [:VOLUME_UOM, text] }

  #Unit
  {UNIT_UOM}    { [:UNIT_UOM, text] }

  #Concentration
  \/            { [:SLASH, text] }
  %             { [:PERCENT, text] }

inner
  def tokenize(code)
    scan_setup(code.downcase)
    @tokens = []
    while token = next_token
      @tokens << token
    end
    @tokens
  end
end
