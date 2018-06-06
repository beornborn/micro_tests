require_relative 'spec_helper'

describe Manager do
  subject(:service_call) { described_class.init_and_handle_bid(initial_data, new_bid) }

  def be val
    expect(service_call.data).to eq val
  end

  context 'new bid is buy' do
    context 'no sell bids for this price' do
      let(:new_bid) { { order: 4, type: :buy, lots: 150, price: 5 } }
      context 'buy with this price exist' do
        let(:initial_data) do
          {
            5 => {
              buy: [
                { order: 1, type: :buy, lots: 100, price: 5, },
                { order: 2, type: :buy, lots: 50, price: 5, },
                { order: 3, type: :buy, lots: 150, price: 5, },
              ],
              sell: []
            }
          }
        end

        it 'correct' do
          be({
            5 => {
              buy: [
                { order: 1, type: :buy, lots: 100, price: 5, },
                { order: 2, type: :buy, lots: 50, price: 5, },
                { order: 3, type: :buy, lots: 150, price: 5, },
                new_bid,
              ],
              sell: [],
            }
          })
        end
      end

      context 'no buy the same price' do
        let(:initial_data) do
          {}
        end

        it 'correct' do
          be({
            5 => {
              buy: [
                new_bid
              ],
              sell: [],
            }
          })
        end
      end
    end
  end

  context 'new bid is sell' do
    context 'no buy bids for this price' do
      let(:new_bid) { { order: 4, type: :sell, lots: 150, price: 5 } }
      context 'sell with this price exist' do
        let(:initial_data) do
          {
            5 => {
              buy: [],
              sell: [
                { order: 1, type: :sell, lots: 100, price: 5, },
                { order: 2, type: :sell, lots: 50, price: 5, },
                { order: 3, type: :sell, lots: 150, price: 5, },
              ],
            }
          }
        end

        it 'correct' do
          be({
            5 => {
              buy: [],
              sell: [
                { order: 1, type: :sell, lots: 100, price: 5, },
                { order: 2, type: :sell, lots: 50, price: 5, },
                { order: 3, type: :sell, lots: 150, price: 5, },
                new_bid,
              ],
            }
          })
        end
      end

      context 'no sell the same price' do
        let(:initial_data) do
          {}
        end

        it 'correct' do
          be({
            5 => {
              buy: [],
              sell: [
                new_bid,
              ],
            }
          })
        end
      end
    end
  end
end
