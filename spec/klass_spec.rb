require_relative 'spec_helper'

describe Klass do
  it 'should return result' do
    expect(described_class.do).to eq 1
  end
end
