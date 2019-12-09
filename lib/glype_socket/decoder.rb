require 'cgi'
require 'base64'
require 'glype_socket/encoder'

class GlypeSocket
  module Decoder
    extend self
    
    #-------------------------------------------------------------------------------------#

    def decode_link(link, config)
      # if base64/arcfour
      if !link.index("%3A%2F%2F")
        [/\&b\=\d+/, /\/b\d+\//].each_with_index do |x, i|
          if link.index(x)
            key = config[:key] || ''
            link = link.slice((link.index(key)+key.length)...link.index(x))
            link.gsub!('/', '').gsub!('_', '%') if i == 1
          end
        end
        link = CGI.unescape(link)
        link = (!config[:salt] && Base64.decode64(link)) ||
          Encoder.arcfour('d', config[:salt], link)
        link = "http#{link}" unless link[0..3].downcase == 'http'
      end
      
      return link
    end

    #-------------------------------------------------------------------------------------#

    def decode(body, config)
      result = ''
      body = CGI.unescapeHTML("#{body}")

      # decrypt content if encrypted
      m = "document.write(arcfour(ginf.enc.u,base64_decode('"
      if body.index(m) && config[:salt]
        t = body.slice((body.index(m)+m.length)..body.length)
        body = Encoder.arcfour('d', config[:salt], t.slice(0...t.index("'")))
      end

      # translated glype-masked links
      [ "/#{config[:script]}?u=",
        "/#{config[:script]}/" ].each_with_index do |id, i|
        m = "[A-Za-z0-9_%.+/]+" + ((i==0 && "&b\=\\d+") || "\/b\\d+/")
        m = Regexp.new(Regexp.escape(id)+m)
        while !(link = body[m]).nil?
          result += body.slice(0...body.index(m))
          body = body.slice((body.index(m)+body[m].length)..body.length)
          result += decode_link(link.sub(id, ''), config)
        end
      end

      return result+body
    end

    #-------------------------------------------------------------------------------------#
  end
end