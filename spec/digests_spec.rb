require 'spec_helper'

describe "Hashit Digests" do
  it 'responds to all the hashing digests' do
    fns = [:md2, :md4, :md5, :sha, :sha1, :sha224, :sha256, :sha384, :sha512]

    expect(Hashit).to respond_to(*fns)
  end

  it 'generates a hash from a key and text' do
    key = "Key"
    text = "Some Text"
    hash = "r6|cd904d6df2122eddf1d6df1240730d29056c171539f171a57ada2a16f5a54bf0"

    expect(Hashit.sha256 key, text).to be == hash
  end

  it 'generates a hash from an array of strings' do
    key = "key"
    text = %w[nitzan gabriel]
    hash = "r6|08665f6532b0b28c1298955e2db2558a7ef06624708ac6cba6e73e88e0351b7d"

    expect(Hashit.sha256 key, text).to be == hash
  end

  it 'generates a recursive hash from an array of keys' do
    key = %w[ron vivi]
    text = "text"
    hash = "r6|54b11c895b426b527bc8c7029b3064d9b48dace3359b143268dac21d472def9c"

    expect(Hashit.sha256 key, text).to be == hash
  end

  it 'converts parameters to strings' do
    key = 32
    text = 45
    hash="r6|ef4f59fe5e91a86be6720d34a0b3413b1119638e271bcc4d2c24dbb7ef6a4bba"

    expect(Hashit.sha256 key, text).to be == hash
  end

  it 'raises an error on invalid parameters' do
    key = nil
    text = 45

    expect{Hashit.sha256 key, text}.to raise_error(ArgumentError)
  end

  it 'generates a timed hash' do
    key = "key"
    text = "some text"
    allow(Hashit).to receive(:current_time).and_return(1408350600)
    hash = Hashit.sha256([key, 1408350600], text)

    expect(Hashit.timed_sha256(key, text)[1..-1]).to be == hash[1..-1]
  end

  it 'generates a previous timed hash' do
    key = "key"
    text = "some text"
    allow(Hashit).to receive(:current_time).and_return(1408350600)
    hash = Hashit.sha256([key, 1408348800], text)

    expect(Hashit.previous_sha256(key, text)[1..-1]).to be == hash[1..-1]
  end

end
