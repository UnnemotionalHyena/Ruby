require 'watir'
require 'json'
require 'date'
load 'account.rb'
load 'transactions.rb'

def open_google(browser)
  browser.goto('https://www.google.com/')
  browser.input(name: 'q').send_keys(':(')
  browser.send_keys :enter
end

def login_MICB(browser, login, password)
  browser.goto('https://wb.micb.md/way4u-wb2/#login')
  browser.li(:class => 'language-item en', :text => "English").click
  browser.input(name: 'login').send_keys(login)
  browser.send_keys :tab
  browser.input(name: 'password').send_keys(password)
  browser.send_keys :tab
  browser.send_keys :enter

  if browser.div(class: "page-message error").exists?
    puts "\nInvalid username or password"
    exit(1)
  end
end

def extract_accounts_data(browser)
  account_list = []

  browser.div(class: 'contract status-active').wait_until_present
  account_data = browser.divs(class: "contract status-active")

  account_data.each do |div|
    string = div.text.split(" ")
    account_list << Account.new(string[1], string[0], string[3], 'Account')
  end

  exctract_card_data(browser, account_list)
  return account_list
end

def exctract_card_data(browser, account_list)
  browser.div(class: 'contract-cards ').wait_until_present

  card_name = browser.divs(class: 'contract-cards ')

  card_name.each do |div|

    div.wait_until_present.click

    card_data = browser.div(class: 'content-header editable ').wait_until_present.text.split(" ")

    account_list << Account.new(card_data[1], card_data[3], card_data[2], 'Card')
    browser.back
  end
end

def hash_accounts (account_data)
  File.open("data.json", "w")

  data_to_file = []

  account_data.each do |account|
    data_to_file.push(account.data_to_hash)
  end

  accounts = {accounts: data_to_file}
  save_to_json("data.json", accounts)
end

def save_to_json (file_to_save, json_data)
  File.open(file_to_save, "w") do |f|
    f.write(JSON.pretty_generate(json_data))
    f.write("\n")
  end
end

def extract_transactions (browser, account_data, nr_months)
  accounts_transactions = []

  browser.li(class: ' tr_history-menu-item').wait_until_present.click
  browser.input(name: 'from').wait_until_present.click

  date = Date.today << nr_months
  (0...nr_months - 1).each{browser.a(title: '< Prev').wait_until_present.click}

  browser.a(class: 'ui-state-default', text: date.day.to_s).wait_until_present.click

  account_data.each do |account|
    transactions = []
    date1 = ''
    bool_tr = true

    browser.div(class: 'filter filter_contract').wait_until_present.click
    browser.span(class: 'contract-name', text: account.name).wait_until_present.click

    begin
    if browser.div(class: 'empty-message').wait_until_present(timeout: 2).exists?
      bool_tr = false
    end
    rescue
    end

    if bool_tr == false
      transactions << Transactions.new('undefine', 'undefine', 0)
    else
      browser.div(class: 'day-operations').wait_until_present

      browser.div(class: 'operations').wait_until_present.divs.each do |div|
        if div.class_name == "month-delimiter"
          date1 = div.text
        elsif div.class_name == "day-operations"
          date2 = "#{date1} #{div.text.split(/\n/)[0]}"

          div.lis.each do |li|
            li = li.text.split(/\n/)
            transactions << Transactions.new("#{date2} #{li[0]}", li[1], li[2])
          end
        end
      end
    end
    accounts_transactions << transactions
  end
  return accounts_transactions
end


def hash_transactions (transaction_data)
  file = eval(File.read('data.json'))

  accounts = file[:accounts]
  counter = 0

  transaction_data.each do |transactions|
    data_to_file = []

    transactions.each {|t| data_to_file.push(t.data_to_hash)}
    accounts[counter] = accounts[counter].merge({transactions: data_to_file})
    counter += 1
  end

  accounts_transactions = {accounts: accounts}
  save_to_json("data.json", accounts_transactions)
end
