require 'spec_helper'
require 'blockchain'
require 'transaction'

RSpec.describe Block do
  describe "initialization" do
    it "starts with a nil hashcode" do
      expect(Block.new([], '0').hashcode).to be_nil
    end
  end

  describe "#mine" do
    it "results in hashcode with starting with number of 0s equal to difficulty" do
      block = Block.new([], '0')
      block.mine(2)
      expect(block.hashcode).to match(/00[0-9a-f]{62}/)
    end
  end
end
