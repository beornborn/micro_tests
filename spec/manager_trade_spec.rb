require_relative 'spec_helper'

describe Manager do
  subject(:service_call) { described_class.init_and_do(initial_data, new_bid) }

  def be val
    expect(service_call.data).to eq val
  end

  def filled

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

    # context 'whole numbers' do
    #   let(:new_bid) do
    #     { order: 4, type: :sell, lots: 150, price: 5 }
    #   end

    #   it 'correct' do
    #     expect(service_call).to eq({
    #       5 => {
    #         buy: [
    #           { order: 1, type: :buy, lots: 50, price: 5, },
    #           { order: 2, type: :buy, lots: 25, price: 5, },
    #           { order: 3, type: :buy, lots: 75, price: 5, },
    #         ],
    #         sell: []
    #       }
    #     })
    #   end
    # end

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
        ])
      end
    end
  end
end
