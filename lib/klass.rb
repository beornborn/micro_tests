require 'awesome_print'
require 'byebug'
require 'active_support/all'

# Vending machine has following coins: 1c, 5c, 10c, 25c, 50c, 1$.
# getChange(5, 0.99) should return [1,0,0,0,0,4]
class Klass
  CAP_SYM = ['!', '?', '.'].freeze
  NON_CAP_SYM = [':', ';'].freeze

  def self.handle_string(input)
    return '' if input.blank?

    input_arr = input.split('')
    result_arr = [input_arr.shift.capitalize]

    current_index = 0
    do_next_space = false
    do_next_cap = false
    while !input_arr[current_index].nil?
      el = input_arr[current_index]

      if do_next_space && el != ' '
        result_arr << el
        do_next_space = false
      end

      if do_next_cap && el != ' ' && !el.in(CAP_SYM) && !el.in(NON_CAP_SYM)
        result_arr << el.capitalize
        do_next_cap = false
        next
      end
    end

    result.join
  end
end



# Write a program that will correct the input string to use proper capitalization and spacing.

# Allowed punctuations are the period ( . ), question mark ( ? ), and exclamation ( ! ) (...).

# Make sure that colons ( : ) and semicolons ( ; ) and all the punctuations are always followed by spaces. Input string will be a valid English sentence.

# Example: "first, solve the problem.then, write the code."
# Output:  "First, solve the problem. Then, write the code."

# Example: "this is a test... and another test."
# Output:  "This is a test... And another test."
