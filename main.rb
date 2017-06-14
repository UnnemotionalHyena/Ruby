load 'functions.rb'
require 'headless'
require 'io/console'

headless = Headless.new
headless.start

browser = Watir::Browser.new :firefox

open_google(browser)

print "Enter the login: "
login = $stdin.gets.chomp

password = STDIN.getpass("\nEnter password: ")

login_MICB(browser, login, password)

account_data = extract_accounts_data(browser)

hash_accounts(account_data)

print("\nNr. of months = ")
nr_months = $stdin.gets.chomp.to_i

transaction_data = extract_transactions(browser, account_data, nr_months)

hash_transactions(transaction_data)