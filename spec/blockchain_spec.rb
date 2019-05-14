require 'spec_helper'
require 'blockchain'
require 'transaction'

RSpec.describe Blockchain do
  describe "initialization" do
    let(:chain) { Blockchain.new }
    let(:genesis_block) { chain.genesis_block }

    it "starts with one genesis block" do
      expect(chain.chain.length).to eq(1)
    end

    it "sets genesis block's previous hashcode to '0'" do
      expect(genesis_block.previous_hashcode).to eq('0')
    end

    it "mines genesis block so it has a hashcode" do
      expect(genesis_block.hashcode).to_not be_nil
    end

    it "starts with no pending transactions" do
      expect(chain.pending_transactions).to be_empty
    end
  end

  describe "#queue_transaction" do
    let(:chain) { Blockchain.new }

    it "adds transaction to pending list" do
      t1 = Transaction.new('Mary', 'Peter', 100)
      chain.queue_transaction(t1)
      t2 = Transaction.new('Peter', 'Mary', 50)
      chain.queue_transaction(t2)
      expect(chain.pending_transactions).to eq([t1, t2])
    end

    it "doesn't accept transaction with amount of 0" do
      trans = Transaction.new('Peter', 'Mary', 0)
      expect { chain.queue_transaction(trans) }.to raise_error(RuntimeError, "Transaction amount must be greater than zero")
    end
  end

  describe "#mine_pending_transactions" do
    let(:chain) { Blockchain.new }
    let(:trans) { Transaction.new('Peter', 'Mary', 100) }

    it "adds new mined block" do
      chain.queue_transaction(trans)
      chain.mine_pending_transactions
      expect(chain.latest_block).to have_attributes(
        transactions: [trans],
        previous_hashcode: chain.genesis_block.hashcode,
        hashcode: match(/[0-9a-f]{64}/)
      )
    end

    it "clears pending transactions" do
      chain.queue_transaction(trans)
      chain.mine_pending_transactions
      expect(chain.pending_transactions).to eq([])
    end
  end

  describe "#wallet_balance" do
    let(:chain) do
      Blockchain.new.tap do |chain|
        chain.queue_transaction(Transaction.new('Mary', 'Peter', 100))
        chain.queue_transaction(Transaction.new('Peter', 'Mary', 50))
        chain.mine_pending_transactions
      end
    end

    it "returns balance considering all transactions" do
      expect(chain.wallet_balance('Peter')).to eq(50)
    end

    it "returns 0 if there are no transactions involving address" do
      expect(chain.wallet_balance('Frank')).to eq(0)
    end
  end
end
