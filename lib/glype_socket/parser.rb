require 'cgi'

class GlypeSocket
  module Parser
    extend self

    #-------------------------------------------------------------------------------------#
    # parse unique_salt from body

    def unique_salt(c)
      m = /enc\:\{u\:\'[\w\d]{128}/
      return (c.is_a?(String) && c[m] && c[m][/[\w\d]{128}/]) || nil
    end

    #-------------------------------------------------------------------------------------#
    # parse redirects from the response header

    def redirect(header)
      if !(i = header.downcase.index("\r\nlocation: ")).nil?
        header = header.slice((i+12)..header.length)
        return header.slice(0...header.index(/\s/))
      end
    end

    #-------------------------------------------------------------------------------------#
    # determine glype script, version, key

    def info(header)
      r = {}
      if header.downcase[/^(get|post)\s{1}/]
        header = header.slice((header.index(/\s/)+1)...header.index(' HTTP/1.'))
      end
      url = header.slice((header.index("://")+3)..header.length).strip
      url = url.slice((url.index('/')+1)..url.length)

      ['?u=', '/'].each do |id|
        next unless url.index(id)
        r[:script] = url.slice(0...url.index(id))
        url = CGI.unescape(url.slice((url.index(id)+id.length)..url.length))
        if id == '?u='
          {'1'=>'aHR0c', '1.0-e'=>'http'}.each do |k, v|
            d = url.index(v)
            r[:version] = k if d
            r[:key] = url.slice(0...d) if d
          end
        else
          d = url.index("aHR0c")
          r[:version] = (d && '1.1') || '1.4'
          r[:key] = url.slice(0...d) if d
        end
      end
      return r
    end

    #-------------------------------------------------------------------------------------#
    # handle known glype error location redirects

    def known_errors(s)
      q = '/index.php?e='
      if s.index(q)
        s = s.slice((s.index(q)+q.length)..s.length)
        return s.slice(0...s.index(/[\&\s]/)).gsub('_', ' ')
      elsif s.index('/index.php')
        return 'redirect to index.php'
      elsif s.index('/donate.php')
        return 'redirect to donate.php'
      end
      return nil
    end

    #-------------------------------------------------------------------------------------#
  end
end
