require "spec_helper"

#-------------------------------------------------------------------------------------#

url = "https://www.google.com/finance"

url_v1 = "http://localhost/browse.php?u=aHR0cHM6Ly93d3cuZ29vZ2xlLmNvbS9maW5hbmNl%0A&b"+
"=0&f=norefer"

url_v1e = "http://localhost/browse.php?u=https%3A%2F%2Fwww.google.com%2Ffinance&b=0&f"+
"=norefer"

url_v11 = "http://localhost/browse.php/czovL3d3/dy5nb29n/bGUuY29t/L2ZpbmFu/Y2U_3D_0/A"+
"/b5/"

url_v14 = "http://localhost/browse.php/4N_2FMvO/2hNbK2oJ/1yjwIyVl/l9TiJRtu/5_2FWXQ_/3"+
"D_0A/b5/"

salt = "zlhzcqTrSRFhc0i9mgm3ym46KwtiGVcvPjJgcGPuZdIaCOggmwNoIaCrnnOCxlK5Uoo7x3kqLvVIS"+
"qARXgfpDH654vfrANY8IEQLnjlifaFCUlA8Ly9Lj2G2mfIgrtNI"

#-------------------------------------------------------------------------------------#

describe GlypeSocket::Encoder do
  config = { host: 'localhost', port: 80, script: 'browse.php' }

  context "version 1" do
    c = config.merge({ version: '1' })
    it "should encode url" do
      expect( GlypeSocket::Encoder.encodeURL(url, c) ).to eq(url_v1)
    end
  end

  context "version 1.0-e" do
    c = config.merge({ version: '1.0-e' })
    it "should encode url" do
      expect( GlypeSocket::Encoder.encodeURL(url, c) ).to eq(url_v1e)
    end
  end

  context "version 1.1" do
    c = config.merge({ version: '1.1' })
    it "should encode url" do
      expect( GlypeSocket::Encoder.encodeURL(url, c) ).to eq(url_v11)
    end
  end

  context "version 1.4" do
    c = config.merge({ version: '1.4', salt: salt })
    it "should encode url" do
      expect( GlypeSocket::Encoder.encodeURL(url, c) ).to eq(url_v14)
    end
  end

end
