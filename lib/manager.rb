require 'awesome_print'
require 'byebug'
require 'active_support/all'

class Manager
  attr_reader :data, :filled

  def initialize data = {}
    @data = data
    @filled = []
  end

  def self.init_and_do data, new_bid
    self.new(data).do(new_bid)
  end

  def do new_bid
    write_new_bid new_bid
    execute_match new_bid
    self
  end

  private

  def write_new_bid new_bid
    @data[new_bid[:price]] ||= {
      buy: [],
      sell: [],
    }

    @data[new_bid[:price]][new_bid[:type]] << new_bid
  end

  def execute_match new_bid
    price = new_bid[:price]
    type = new_bid[:type]
    opposite_lots = @data[price][reverse_type(type)].map {|x| x[:lots] }.sum

    trade_lots = [opposite_lots, new_bid[:lots]].min
    return if trade_lots == 0

    trade_for price, type, trade_lots
    trade_for price, reverse_type(type), trade_lots
  end

  def trade_for price, type, lots
    sum_lots = @data[price][type].map {|x| x[:lots] }.sum
    if sum_lots <= lots
      @data[price][type].each {|x| x[:type] = 'filled' }
      @filled.push(*@data[price][type])
      @data[price][type].clear
    end
  end

  def reverse_type type
    return :sell if type == :buy
    return :buy if type == :sell
  end
end

def solution(a)
  sorted = a.sort
  start = 0
  result = 0

  a.each_index do |i|
    next if a[start..i].sort != sorted[start..i]
    start = i + 1
    result += 1
  end

  result
end






