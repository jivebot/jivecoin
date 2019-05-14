require 'digest'
require 'json'

class Block
  attr_reader :transactions, :previous_hashcode, :timestamp, :hashcode

  def initialize(transactions, previous_hashcode, timestamp: nil)
    @transactions = transactions
    @previous_hashcode = previous_hashcode
    @timestamp = timestamp || Time.now
    @nonce = 0
    @hashcode = nil
  end

  def mine(difficulty)
    loop do
      @hashcode = calculate_hash
      break if @hashcode.start_with?('0' * difficulty)
      @nonce += 1
    end
  end

  def calculate_hash
    sha = Digest::SHA2.new
    sha << @previous_hashcode
    sha << @timestamp.to_s
    sha << @transactions.map(&:as_json).to_json
    sha << @nonce.to_s
    sha.hexdigest
  end
end
