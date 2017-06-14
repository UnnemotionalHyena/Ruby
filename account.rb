
class Account

    attr_reader :name, :currency, :balance, :nature

    def initialize()
        @name = ""
        @currency = ""
        @balance = 0
        @nature = ""
    end

    def set_name(name)
        @name = name
    end

    def set_currency(currency)
        @currency = currency
    end

    def set_balance(balance)
        @balance = balance
    end

    def set_nature(nature)
        @nature = nature
    end

    def print_values()

        print "Name = ", @name, "\n", "Currency = ", @currency, "\n", "Balance = ", @balance, "\n", "Nature = ", @nature, "\n"

    end

    def data_to_hash()
        return {
            :name => @name,
            :currency => @currency,
            :balance => @balance,
            :nature => @nature
        }
    end

end
