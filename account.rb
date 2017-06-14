
class Account
  attr_accessor :name, :currency, :balance, :nature

  def initialize(name, currency, balance, nature)
    @name = name
    @currency = currency
    @balance = balance
    @nature = nature
  end

  def data_to_hash
    return {
      :name => @name,
      :currency => @currency,
      :balance => @balance,
      :nature => @nature
    }
  end
end
