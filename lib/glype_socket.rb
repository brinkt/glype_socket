require 'cgi'
require 'web_socket'

require 'glype_socket/decoder'
require 'glype_socket/encoder'
require 'glype_socket/parser'
require 'glype_socket/validator'
require 'glype_socket/version'

class GlypeSocket
  class Sock < WebSocket
    attr_accessor :config

    def initialize(opts={})
      super(opts)

      opts = {} unless opts.is_a?(Hash)
      raise 'invalid host' if !Validator.host?(opts[:host])
      raise 'invalid port' if opts[:port] && !Validator.port?(opts[:port])
      raise 'invalid script' if opts[:script] && !Validator.script?(opts[:script])
      raise 'invalid version' if opts[:version] && !Validator.version?(opts[:version])
      opts[:port] = 80 unless opts[:port]

      @config = opts
    end

    #-------------------------------------------------------------------------------------#
    # clear target url cookies

    def clear_cookies!
      @cookie.keys.each { |k| @cookie.delete(k) if k[0..1] == 'c[' } if @cookie.is_a?(Hash)
    end

    #-------------------------------------------------------------------------------------#
    # requires a glype-encoded url

    def fetch(method, url, postdata=nil)
      prepare(@config[:host], method, url, postdata)
      submit(@config[:host], @config[:port])

      # if http header location redirects
      if !(r = Parser.redirect(@response[:header])).nil?
        if !(e = Parser.known_errors(r)).nil?
          # handle known errors
          @response = { header: 'error', body: e }
        else
          fetch('get', r) # automatically follow redirects
        end
      else
        # determine glype script, version, key
        if !@config[:script] && !@config[:version] && @cookie['s']
          @config.merge!(Parser.info(@request))
        end

        @config[:salt] = Parser.unique_salt(@response[:body])
        @response[:body] = Decoder.decode(@response[:body], @config)
      end
    end

    #-------------------------------------------------------------------------------------#

    def get(url)
      if Validator.config?(@config)
        # encodes a URL with glype, then fetches
        url = Encoder.encodeURL(url, @config)
        fetch('get', url)
      else
        # fetches without knowing how to encode
        # has to follow 1-2 redirects before obtaining data
        fetch('post', "/includes/process.php?action=update",
          "u=#{CGI.escape(url)}&encodeURL=on&allowCookies=on")
      end
    end

    #-------------------------------------------------------------------------------------#
  end
end