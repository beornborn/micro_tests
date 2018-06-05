require 'awesome_print'
require 'byebug'
require 'active_support/all'

class Klass
  def self.do
    ap 'qweqwe'
    1
  end
end


Klass.do
