class Unit::Lexer
option
  ignorecase
macro
  BLANK       [\ \t]+
  SCIENTIFIC  -?\d\.?\d*[Ee][\+\-]?\d+
  SCALAR      [-+]?[0-9]*\.?[0-9]+
  MASS_UOM    \b(?:mcg|mg|g)\b
  VOLUME_UOM  \b(?:ml|l)\b
  UNIT_UOM    \b(?:unit|u)\b
  UNITLESS_UOM \b(?:each|ea)\b
  EQUIVALENCE_UOM \b(?:meq|eq)\b
  COLON       [:]

rule
  {BLANK}
  {SCIENTIFIC}  { [:SCALAR, BigDecimal.new(text, 10)] }
  {SCALAR}      { [:SCALAR, BigDecimal.new(text, 10)] }
  {COLON}       { [:COLON, text] }

  #Mass
  \b(?:gm|gram)\b    { [:MASS_UOM, 'g'] }
  {MASS_UOM}    { [:MASS_UOM, text] }

  #Volume
  {VOLUME_UOM}  { [:VOLUME_UOM, text] }

  #Unit
  {UNIT_UOM}    { [:UNIT_UOM, text] }

  #Unitless uom
  {UNITLESS_UOM} {[:UNITLESS_UOM, 'ea'] }

  #Equivalence uom
  {EQUIVALENCE_UOM} {[:EQUIVALENCE_UOM, text] }

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
