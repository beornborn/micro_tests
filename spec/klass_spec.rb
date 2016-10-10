require_relative 'spec_helper'

describe Klass do
  it "should return result" do
    str = 'first, solve the problem.then, write the code.'
    solution = "First, solve the problem. Then, write the code."
    expect(described_class.handle_string(str)).to eq solution
    # str = "this is a test... and another test."
    # solution = "This is a test... And another test."
    # expect(described_class.handle_string(str)).to eq solution
  end
end

# getChange(3.14, 1.99) should return [0,1,1,0,0,1]
# getChange(4, 3.14) should return [1,0,1,1,1,0]
# getChange(0.45, 0.34) should return [1,0,1,0,0,0]
# Write a program that will correct the input string to use proper capitalization and spacing.

# Allowed punctuations are the period ( . ), question mark ( ? ), and exclamation ( ! ) (...).

# Make sure that colons ( : ) and semicolons ( ; ) and all the punctuations are always followed by spaces. Input string will be a valid English sentence.

# Example: "first, solve the problem.then, write the code."
# Output:  "First, solve the problem. Then, write the code."

# Example: "this is a test... and another test."
# Output:  "This is a test... And another test."
