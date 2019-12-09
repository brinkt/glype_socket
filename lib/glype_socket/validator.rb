class GlypeSocket
  module Validator
    extend self

    # estimated versions (not actual)
    VERSIONS = ['1', '1.0-e', '1.1', '1.4']

    #-------------------------------------------------------------------------------------#
    # validations

    def host?(h); (h.is_a?(String) && h.length > 0 && true) || false; end
    def port?(p); (p.is_a?(Integer) && p > 0 && p <= 65535 && true) || false; end
    def script?(s); (s.is_a?(String) && s.length > 0 && true) || false; end
    def version?(v); VERSIONS.include?(v); end

    def config?(c)
      ( c.is_a?(Hash) && host?(c[:host]) && port?(c[:port]) &&
        script?(c[:script]) && version?(c[:version]) && true ) || false
    end
    
    #-------------------------------------------------------------------------------------#
  end
end
