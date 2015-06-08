require_relative 'spec_helper'

describe Klass do
  let(:meth) { Klass.method :meth }

  it "should return result" do
    expect(meth.call('arg')).to eq [1,2,3]
  end
end
