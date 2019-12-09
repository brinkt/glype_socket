require "spec_helper"

#-------------------------------------------------------------------------------------#
# redirect location header

rh = %{HTTP/1.1 302 Found\r
Server: nginx/1.10.0\r
Content-Type: text/html\r
Content-Length: 0\r
Connection: close\r
X-Powered-By: PHP/5.4.45\r
Set-Cookie: s=3be65579786cc3317321a8918fd98774; path=/\r\nCache-Control: private\r
Location: https://localhost/browse.php/NKK9f0s_/2B8KutJt/lcS1aFrh/0_3D/b5/fnorefer\r
Cache-Control: public\r\n\r
}

rh_url = "https://localhost/browse.php/NKK9f0s_/2B8KutJt/lcS1aFrh/0_3D/b5/fnorefer"

#-------------------------------------------------------------------------------------#
# unique_salt

us = "ginf={url:'https://www.sslproxyfree.com',script:'browse.php',target:{h:'https:/"+
"/www.google.com',p:'/',b:'',u:'https://www.google.com/?gws_rd=ssl'},enc:{u:'w1ZPYS8n"+
"ajYrwMJi9cZsrMT959SaX5yhUnUJ4TU20JkmjTugTiz8Ug8OfOO0Hc7soSZizH8pgizpZRuIZRHIXDm1fYRM"+
"ZN2bvPhSnf5rouFdbZKZGfxrIHiLt0lgDchW',e:'1',x:'',p:'1'},b:'5',override:1,test:1}</sc"+
"ript>}"

salt = "w1ZPYS8najYrwMJi9cZsrMT959SaX5yhUnUJ4TU20JkmjTugTiz8Ug8OfOO0Hc7soSZizH8pgizpZ"+
"RuIZRHIXDm1fYRMZN2bvPhSnf5rouFdbZKZGfxrIHiLt0lgDchW"

#-------------------------------------------------------------------------------------#
# known errors

ke = "Location: https://localhost/index.php?e=http_error&whatever=else\r"

#-------------------------------------------------------------------------------------#

describe GlypeSocket::Parser do

  context "http header & body" do

    it "should redirect" do
      expect( GlypeSocket::Parser.redirect(rh) ).to eq(rh_url)
    end

    it "should parse unique salt" do
      expect( GlypeSocket::Parser.unique_salt(us) ).to eq(salt)
    end

    it "should handle known errors" do
      expect( GlypeSocket::Parser.known_errors(ke) ).to eq('http error')
    end

  end

  #-------------------------------------------------------------------------------------#

  context "version 1.4 link" do

    it "should determine info" do
      info = GlypeSocket::Parser.info(rh_url)
      expect( info ).to be_a Hash
      expect( info ).to include :script
      expect( info[:script] ).to eq 'browse.php'
      expect( info ).to include :version
      expect( info[:version] ).to eq '1.4'
    end
  end

  #-------------------------------------------------------------------------------------#
end
