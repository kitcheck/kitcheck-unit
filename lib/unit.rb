require "unit/version"
require "unit/formatter"
require "unit/parser"
require "unit/base"
require "unit/unit"
require "unit/mass"
require "unit/volume"
require "unit/concentration"
require "unit/equivalence"
require "unit/errors"
require "bigdecimal"
require 'strscan'


module Unit
  def self.parse(string)
    tokens = Lexer.new.tokenize(string)
    Parser.new.parse(tokens)
  rescue
    raise IncompatibleUnitsError.new("#{string} is not a valid unit string")
  end

  def self.from_scalar_and_uom(scalar, uom)
    self.parse("#{scalar} #{uom}")
  end
end
