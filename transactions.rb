
class Transactions

    def initialize()
        @date = ""
        @description = ""
        @amount = 0
    end

    def set_date(date)
        @date = date
    end

    def set_description(description)
        @description = description
    end

    def set_amount(amount)
        @amount = amount
    end

    def print_values()
        print "date = ", @date, "\ndescription = ", @description, "\namount = ", @amount
    end

    def data_to_hash()
        return {
            :date => @date,
            :description => @description,
            :amount => @amount,
        }
    end

end
