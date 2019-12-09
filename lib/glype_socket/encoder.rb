require 'cgi'
require 'base64'
require 'glype_socket/validator'

class GlypeSocket
  module Encoder
    extend self

    #-------------------------------------------------------------------------------------#
    # encode URL according to glype specification

    def encodeURL(url, config)
      raise 'invalid url' unless url.is_a?(String)
      raise 'invalid config' unless Validator.config?(config)

      temp = 'http'; temp += 's' if config[:port] == 443
      temp += "://#{config[:host]}/#{config[:script]}"
      
      if config[:version] != '1.0-e'
        url.sub!(/^http/, '') if config[:version] != '1'
        url = (config[:salt] && arcfour('e', config[:salt], url)) || Base64.encode64(url)
      end
      url = CGI.escape(url)

      if ['1', '1.0-e'].include?(config[:version])
        temp += "?u=#{config[:key]}#{url}&b=0&f=norefer"
      else
        url = url.scan(/.{1,8}/).join('/').gsub('%', '_')
        temp += "/#{config[:key]}#{url}/b5/"
      end
      
      return temp
    end

    #-------------------------------------------------------------------------------------#
    # glype's way to obfuscate the URL

    def arcfour(m,u,d)
      d = Base64.decode64(d) if m == 'd'
      o = ''; s = []; n = 256; l = u.length
      (0...n).map{ |i| s[i] = i }

      j = 0
      (0...n).each do |i|
        j = (j + s[i] + u[i%l].ord) % n
        x = s[i]; s[i] = s[j]; s[j] = x
      end
      
      i = j = 0
      (0...d.length).each do |y|
        i = (i+1) % n
        j = (j+s[i]) % n
        x = s[i]; s[i] = s[j]; s[j] = x
        o += (d[y].ord ^ s[(s[i]+s[j])%n]).chr
      end

      o = Base64.encode64(o) if m == 'e'
      return o
    end

    #-------------------------------------------------------------------------------------#
    # generate random unique_salt

    def random_salt
      charset = ('A'..'Z').to_a + ('a'..'z').to_a + (0..9).map(&:to_s)
      return (0...128).map{ charset[rand(charset.size)] }.join
    end

    #-------------------------------------------------------------------------------------#
  end
end