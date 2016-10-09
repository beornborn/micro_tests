require_relative 'spec_helper'

describe Klass do
  it "should return result" do
    expect(described_class.meth(1)).to eq false
  end
end
