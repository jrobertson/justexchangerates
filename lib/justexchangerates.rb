#!/usr/bin/env ruby

# file: justexchangerates.rb

require 'json'
require 'open-uri'


class JustExchangeRates

  attr_reader *%i(base date rates)

  def initialize(api:'https://api.fixer.io/latest?base=', base: 'USD')

    response = open(api + base.upcase)

    if response.status.last == "OK" then

      h = JSON.parse(response.read)
      @base, @date, @rates = h['base'], h['date'], h['rates']

    else
      puts "JustExchangeRates API error %s : %s" % response.status
    end
  
  end

  def rate(currency)
    @rates[currency.upcase]
  end

end

if __FILE__ == $0 then

  jer = JustExchangeRates.new(base: 'USB')
  jer.rate(VARGS.first) # e.g. GBP #=> 0.73792

end