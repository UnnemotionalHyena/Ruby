
class Transactions
  attr_accessor :date, :description, :amount

  def initialize(date, description, amount)
    @date = date
    @description = description
    @amount = amount
  end

  def data_to_hash
    return {
      :date => @date,
      :description => @description,
      :amount => @amount,
    }
  end
end
