require 'spec_helper'

describe "Hashit Verifier" do

  it 'can verify an old hash' do
    hash = "r6|cd904d6df2122eddf1d6df1240730d29056c171539f171a57ada2a16f5a54bf0"
    key = "Key"
    text = "Some Text"

    expect(Hashit.matches? hash, key, text).to be true
  end

  it 'raises an error on invalid parameters' do
    hash = "cd904d6df2122eddf1d6df1240730d29056c171539f171a57ada2a16f5a54bf0"
    key = "Key"
    text = "Some Text"

    expect{Hashit.matches? hash, key, text}.to raise_error(ArgumentError)
  end

  it 'matches timed hashes' do
    key = "Key"
    text = "Some Text"
    allow(Hashit).to receive(:current_time).and_return(1408350600)
    hash = Hashit.timed_sha256 key, text

    expect(Hashit.matches? hash, key, text).to be true
  end

  it 'matches previous hashes' do
    key = "Key"
    text = "Some Text"
    allow(Hashit).to receive(:current_time).and_return(1408350600)
    hash = Hashit.previous_sha256 key, text

    expect(Hashit.matches? hash, key, text).to be false
    expect(Hashit.did_match? hash, key, text).to be true
  end
end
