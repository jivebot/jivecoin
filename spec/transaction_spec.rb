require 'spec_helper'
require 'transaction'

RSpec.describe Transaction do
  describe "#as_json" do
    it "returns JSON-friendly hash" do
      time = Time.now
      trans = Transaction.new('Fred', 'Amy', 100, timestamp: time)
      expect(trans.as_json).to eq({
        fromAddress: 'Fred',
        toAddress: 'Amy',
        amount: 100,
        timestamp: time
      })
    end
  end
end