#!/usr/bin/env ruby

# file: justexchangerates.rb

require 'json'
require 'open-uri'
require 'chronic_duration'


class JustExchangeRates

  attr_reader *%i(base date rates)

  def initialize(api:'https://api.fixer.io/latest?base=', base: 'USD', 
                 cache_refresh: '1 week', cache_path: '.', debug: false)

    @url, @base, @debug = api, base, debug
    
    filename = 'justexchangerates_' + base.downcase + '.json'    
    @cache_filepath = File.join(cache_path, filename)
      
    h = if cache_refresh then      
            
      if File.exists? @cache_filepath then
        
        h2 = JSON.parse(File.read @cache_filepath)
        seconds = ChronicDuration.parse(cache_refresh) 

        if (Time.parse(h2['date']) + seconds) < Time.now then
          fetch_rates
        else
          puts 'fetching rates from local cache ...' if @debug
          h2
        end
        
      else
        fetch_rates
      end        
      
    else
      
      fetch_rates
      
    end
    

    @base, @date, @rates = h['base'], h['date'], h['rates']    
  
  end

  def rate(currency)
    @rates[currency.upcase]
  end
  
  private
  
  def fetch_rates()

    response = open(@url + @base.upcase)

    if response.status.last == "OK" then

      h = JSON.parse(response.read)
      h['date'] = Time.now
      File.write @cache_filepath, h.to_json
      h

    else
      puts "JustExchangeRates API error %s : %s" % response.status
      {}
    end          
    
  end

end

if __FILE__ == $0 then

  jer = JustExchangeRates.new(base: 'USD')
  jer.rate(VARGS.first) # e.g. GBP #=> 0.73792

end
