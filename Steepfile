D = Steep::Diagnostic

target :lib do
  signature "sig"

  check "lib"                       # Directory name
  # check "lib/bitint/bitint.rb"
  # check "Gemfile"                   # File name
  # ignore "lib/templates/*.rb"
  ignore 'lib/bitint/refinements.rb'

  # library "pathname", "set"       # Standard libraries
  # library "strong_json"           # Gems
  
  # configure_code_diagnostics(D::Ruby.strict)       # `strict` diagnostics setting
  # configure_code_diagnostics(D::Ruby.lenient)      # `lenient` diagnostics setting
  configure_code_diagnostics do |hash|             # You can setup everything yourself
    hash[D::Ruby::UnknownConstant] = :hint
  end
end

# target :test do
#   signature "sig", "sig-private"
#
#   check "test"
#
#   # library "pathname", "set"       # Standard libraries
# end
