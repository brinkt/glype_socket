require "spec_helper"

describe GlypeSocket do

  it "has a version number" do
    expect(GlypeSocket::VERSION).not_to be nil
  end

  #-------------------------------------------------------------------------------------#

  context "#new" do

    c = { host: 'localhost', port: 80 }
    glype = GlypeSocket::Sock.new(c)
    ip_match = Regexp.new(/^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/)

    # defaults are set through parent class WebSocket

    # defaults to nil
    it "validates local ip" do
      expect( glype.parse_opts(c.merge({ip: 0}))[:ip] ).to be_nil
      expect( glype.parse_opts(c.merge({ip: ''}))[:ip] ).to be_nil
      expect( glype.parse_opts(c.merge({ip: '192.168.1'}))[:ip] ).to be_nil
      expect( glype.parse_opts(c.merge({ip: '192.168.1.1'}))[:ip] ).to match ip_match
      expect( glype.parse_opts(c.merge({ip: '127.0.0.1'}))[:ip] ).to match ip_match
    end

    # defaults to: true
    it "validates cookies" do
      expect( glype.parse_opts(c.merge({cookies: true}))[:cookies] ).to be true
      expect( glype.parse_opts(c.merge({cookies: nil}))[:cookies] ).to be true
      expect( glype.parse_opts(c.merge({cookies: 0}))[:cookies] ).to be true
      expect( glype.parse_opts(c.merge({cookies: ''}))[:cookies] ).to be true
      expect( glype.parse_opts(c.merge({cookies: Hash.new}))[:cookies] ).to be true
      expect( glype.parse_opts(c.merge({cookies: false}))[:cookies] ).to be false
    end

    # defaults to reasonable integer > 0
    it "validates timeout" do
      expect( glype.parse_opts(c.merge({timeout: true}))[:timeout] ).to be > 0
      expect( glype.parse_opts(c.merge({timeout: nil}))[:timeout] ).to be > 0
      expect( glype.parse_opts(c.merge({timeout: 0}))[:timeout] ).to be > 0
      expect( glype.parse_opts(c.merge({timeout: ''}))[:timeout] ).to be > 0
      expect( glype.parse_opts(c.merge({timeout: Hash.new}))[:timeout] ).to be > 0
      expect( glype.parse_opts(c.merge({timeout: 5}))[:timeout] ).to eq(5)
    end

  end

  #-------------------------------------------------------------------------------------#
end
