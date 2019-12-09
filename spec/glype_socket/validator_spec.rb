require "spec_helper"

describe GlypeSocket::Validator do
  v = GlypeSocket::Validator

  it "validates config not hash" do
    expect( v.config?(nil) ).to be false
  end

  it "validates host" do
    expect( v.host?(nil) ).to be false
    expect( v.host?(0) ).to be false
    expect( v.host?('') ).to be false
    expect( v.host?('localhost') ).to be true
    expect( v.host?('nil') ).to be true
  end

  it "validates port" do
    expect( v.port?(nil) ).to be false
    expect( v.port?(0) ).to be false
    expect( v.port?(80) ).to be true
    expect( v.port?(443) ).to be true
    expect( v.port?(8080) ).to be true
  end

  it "validates script" do
    expect( v.script?(nil) ).to be false
    expect( v.script?('') ).to be false
    expect( v.script?(0) ).to be false
    expect( v.script?(Hash.new) ).to be false
    expect( v.script?('browse.php') ).to be true
  end

  it "validates version" do
    expect( v.version?(nil) ).to be false
    expect( v.version?('') ).to be false
    expect( v.version?(0) ).to be false
    expect( v.version?(Hash.new) ).to be false
    expect( v.version?('1') ).to be true
    expect( v.version?('1.0-e') ).to be true
    expect( v.version?('1.1') ).to be true
    expect( v.version?('1.4') ).to be true
  end

end
