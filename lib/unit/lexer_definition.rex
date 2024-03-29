class Unit::Lexer
option
  ignorecase
macro
  BLANK       [\ \t]+
  SCIENTIFIC  -?[\d.]+\d*[Ee][\+\-]?\d+
  SCALAR      [-+]?[0-9]*\.?[0-9]+
  MASS_UOM    \b(?:mcg|mg|g|kg)\b
  VOLUME_UOM  \b(?:ml|l)\b
  TIME_UOM    \b(?:min|hr)\b
  PATCH_UOM   \b(?:patch|ptch)\b
  UNIT_UOM    \b(?:unit|u)\b
  UNITLESS_UOM \b(?:each|ea)\b
  EQUIVALENCE_UOM \b(?:meq|eq)\b
  COLON       [:]

rule
  {BLANK}
  {SCIENTIFIC}  { [:SCALAR, BigDecimal(text, 10)] }
  {SCALAR}      { [:SCALAR, BigDecimal(text, 10)] }
  {COLON}       { [:COLON, text] }

  #Mass
  \b(?:gm|gram)\b    { [:MASS_UOM, 'g'] }
  {MASS_UOM}    { [:MASS_UOM, text] }

  #Volume
  {VOLUME_UOM}  { [:VOLUME_UOM, text] }

  #Time
  {TIME_UOM}  { [:TIME_UOM, text] }

  #PATCH
  {PATCH_UOM}    { [:PATCH_UOM, 'patch'] }

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
