require 'block'

class Blockchain
  DEFAULT_DIFFICULTY = 2
  DEFAULT_REWARD = 100

  attr_reader :chain, :pending_transactions, :difficulty

  def initialize(difficulty: DEFAULT_DIFFICULTY, mining_reward: DEFAULT_REWARD)
    @chain = [build_genesis_block]
    @pending_transactions = []
    @difficulty = difficulty
    @mining_reward = mining_reward
  end
  
  def queue_transaction(transaction)
    if transaction.amount <= 0
      raise "Transaction amount must be greater than zero"
    end

    @pending_transactions << transaction
  end

  def mine_pending_transactions(mining_reward_address: nil)
    if mining_reward_address
      reward_trans = Transaction.new(nil, mining_reward_address, @mining_reward)
      queue_transaction(reward_trans)
    end

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
