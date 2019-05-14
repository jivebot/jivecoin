class Transaction
  attr_reader :from_address, :to_address, :amount, :timestamp

  def initialize(from_address, to_address, amount, timestamp: nil)
    @from_address = from_address
    @to_address = to_address
    @amount = amount
    @timestamp = timestamp || Time.now
  end

  def as_json
    {
      fromAddress: @from_address,
      toAddress: @to_address,
      amount: @amount,
      timestamp: @timestamp
    }
  end
end
