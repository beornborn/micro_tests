require_relative 'spec_helper'

describe Manager do
  subject(:service_call) { described_class.init_and_handle_bid(initial_data, new_bid) }

  def be val
    expect(service_call.data).to eq val
  end

  def filled val
    expect(service_call.filled).to match_array val
  end

  context 'new bid is sell' do
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

    context 'more than buys' do
      let(:new_bid) do
        { order: 4, type: :sell, lots: 301, price: 5 }
      end

      it 'correct' do
        be({
          5 => {
            buy: [],
            sell: [
              { order: 4, type: :sell, lots: 1, price: 5, },
            ]
          }
        })
        filled([
          { order: 1, type: :buy, lots: 100, price: 5, },
          { order: 2, type: :buy, lots: 50, price: 5, },
          { order: 3, type: :buy, lots: 150, price: 5, },
          { order: 4, type: :sell, lots: 300, price: 5 }
        ])
      end
    end

    context 'less than buy, whole numbers' do
      let(:new_bid) do
        { order: 4, type: :sell, lots: 150, price: 5 }
      end

      it 'correct' do
        be({
          5 => {
            buy: [
              { order: 1, type: :buy, lots: 50, price: 5, },
              { order: 2, type: :buy, lots: 25, price: 5, },
              { order: 3, type: :buy, lots: 75, price: 5, },
            ],
            sell: []
          }
        })
        filled([
          { order: 1, type: :buy, lots: 50, price: 5, },
          { order: 2, type: :buy, lots: 25, price: 5, },
          { order: 3, type: :buy, lots: 75, price: 5, },
          { order: 4, type: :sell, lots: 150, price: 5 }
        ])
      end
    end

    context 'less than buy, fractional numbers' do
      let(:new_bid) do
        { order: 4, type: :sell, lots: 200, price: 5 }
      end

      it 'correct' do
        be({
          5 => {
            buy: [
              { order: 1, type: :buy, lots: 33, price: 5, },
              { order: 2, type: :buy, lots: 17, price: 5, },
              { order: 3, type: :buy, lots: 50, price: 5, },
            ],
            sell: []
          }
        })
        filled([
          { order: 1, type: :buy, lots: 67, price: 5, },
          { order: 2, type: :buy, lots: 33, price: 5, },
          { order: 3, type: :buy, lots: 100, price: 5, },
          { order: 4, type: :sell, lots: 200, price: 5 }
        ])
      end
    end
  end
end
