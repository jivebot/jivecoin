require 'block'

class Blockchain
  DEFAULT_DIFFICULTY = 2

  attr_reader :chain, :pending_transactions, :difficulty

  def initialize(difficulty: DEFAULT_DIFFICULTY)
    @chain = [build_genesis_block]
    @pending_transactions = []
    @difficulty = difficulty
  end
  
  def queue_transaction(transaction)
    if transaction.amount <= 0
      raise "Transaction amount must be greater than zero"
    end

    @pending_transactions << transaction
  end

  def mine_pending_transactions
    block = Block.new(@pending_transactions, latest_block.hashcode)
    block.mine(@difficulty)

    @chain << block
    @pending_transactions = []    
  end

  def wallet_balance(address)
    transactions.inject(0) do |balance, trans|
      balance -= trans.amount if trans.from_address == address
      balance += trans.amount if trans.to_address == address
      balance
    end
  end

  def genesis_block
    @chain.first
  end

  def latest_block
    @chain.last
  end

  def transactions
    chain.flat_map(&:transactions)
  end

  private

  def build_genesis_block
    Block.new([], '0').tap { |b| b.mine(0) }
  end
end
