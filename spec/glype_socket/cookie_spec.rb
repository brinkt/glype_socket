require "spec_helper"

cookie_header = %{HTTP/1.1 200 OK\r
Server: nginx/1.10.0\r
Content-Type: text/html; charset=utf-8\r
Transfer-Encoding: chunked\r
Connection: close\r
X-Powered-By: PHP/5.4.45\r
Set-Cookie: s=a89c19f7ba7afda85abfaa3d9d129437; path=/\r
Set-Cookie: c[facebook.com][/][datr]=yPU0WI_6ZYliJUn-RA_9w6Fx; path=/\r
Set-Cookie: c[facebook.com][/][fr]=0r8NOdhNfo6boSdFV..BYNP.0.BYNPXI.-SA96; path=/\r
Set-Cookie: c[facebook.com][/][m_ts]=1479865800; path=/\r
Content-Encoding: gzip\r
}

#-------------------------------------------------------------------------------------#

describe GlypeSocket::Sock do
  g = GlypeSocket::Sock.new({ host: 'localhost', port: 80 })

  context "manipulates header w/multiple cookies" do
    g.set_cookies(cookie_header)

    it "should set 4 cookies" do
      expect( g.cookie ).to be_kind_of Hash
      expect( g.cookie ).to include 's'
      expect( g.cookie['s'] ).to eq 'a89c19f7ba7afda85abfaa3d9d129437'
      expect( g.cookie ).to include 'c[facebook.com][/][datr]'
      expect( g.cookie['c[facebook.com][/][datr]'] ).to eq 'yPU0WI_6ZYliJUn-RA_9w6Fx'
      expect( g.cookie ).to include 'c[facebook.com][/][fr]'
      expect( g.cookie['c[facebook.com][/][fr]'] ).to eq '0r8NOdhNfo6boSdFV..BYNP.0.BYNPXI.-SA96'
      expect( g.cookie ).to include 'c[facebook.com][/][m_ts]'
      expect( g.cookie['c[facebook.com][/][m_ts]'] ).to eq '1479865800'
    end

    it "should remove 3 nested target cookies" do
      g.clear_cookies!
      expect( g.cookie ).to be_kind_of Hash
      expect( g.cookie ).to contain_exactly ['s', 'a89c19f7ba7afda85abfaa3d9d129437']
    end

  end

end
