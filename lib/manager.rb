require 'awesome_print'
require 'byebug'
require 'active_support/all'

class Manager
  attr_reader :data, :filled

  def initialize data = {}
    @data = data
    @filled = []
  end

  def self.init_and_handle_bid data, new_bid
    self.new(data).handle_bid(new_bid)
  end

  def handle_bid new_bid
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
      @filled.push(*@data[price][type])
      @data[price][type].clear
    else
      @data[price][type] = get_bid_trade_lots(price, type, sum_lots, lots)

      @data[price][type].each do |bid|
        bid.delete(:bid_trade_lots_remain)
        filled_bid = bid.clone
        filled_bid[:lots] = filled_bid[:bid_trade_lots_whole]
        bid.delete(:bid_trade_lots_whole)
        filled_bid.delete(:bid_trade_lots_whole)
        @filled << filled_bid
      end
    end
  end

  def get_bid_trade_lots price, type, sum_lots, lots
    bids = @data[price][type].clone

    bids.each do |bid|
      bid[:bid_trade_lots_whole] = (bid[:lots] * lots / sum_lots.to_f).floor
      bid[:bid_trade_lots_remain] = (bid[:lots] * lots / sum_lots.to_f) - bid[:bid_trade_lots_whole]
    end

    remain_pool = lots - bids.map {|x| x[:bid_trade_lots_whole] }.sum
    initial_order = bids.map {|x| x[:order] }
    bids = bids.sort_by {|x| x[:bid_trade_lots_remain]}.reverse

    i = 0
    while remain_pool > 0
      bids[i][:bid_trade_lots_whole] += 1
      i += 1
      remain_pool -= 1
    end

    bids.each do |x|
      x[:lots] -= x[:bid_trade_lots_whole]
    end
    bids.sort_by {|x| initial_order.find_index(x[:order])}
  end

  def reverse_type type
    return :sell if type == :buy
    return :buy if type == :sell
  end
end
