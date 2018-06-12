#!/usr/bin/env ruby

# file: justexchangerates.rb

require 'json'
require 'open-uri'
require 'chronic_duration'
require 'open_exchange_rates'


# Note: To use this gem you need an **app id** which you can get when 
# registering for free from https://openexchangerates.org/signup/free

class JustExchangeRates

  attr_reader *%i(base date rates)

  def initialize(base: 'USD', cache_refresh: '1 week', cache_path: '.', \
                 debug: false, app_id: nil)

    @base, @debug, @app_id, @cache_refresh = base, debug, app_id, cache_refresh
    
    filename = 'justexchangerates_' + base.downcase + '.json'    
    @cache_filepath = File.join(cache_path, filename)
      
    h = if cache_refresh then      
            
      if File.exists? @cache_filepath then
        
        JSON.parse(File.read(@cache_filepath), {:symbolize_names => true})
        
      else
        {base: @base, date: Time.now, rates: {}}
      end        
            
    end
    
    puts 'h: ' + h.inspect if debug
    
    @base, @date, @rates = h[:base], h[:date], h[:rates]    
  
  end

  def rate(currency)
    
    if @rates.has_key? currency.upcase.to_sym then
      
      seconds = ChronicDuration.parse(@cache_refresh) 
      puts 'seconds: ' + seconds.inspect if @debug
      t = (Time.parse(rates[currency.upcase.to_sym].last) \
          + seconds)
      puts 't: ' + t.inspect if @debug
      if t > Time.now then
        rates[currency.upcase.to_sym].first
      else
        fetch_rate currency
      end
      
    else
      fetch_rate currency
    end
    
  end
  
  
  private
  
  def fetch_rate(currency)
    
    puts 'inside fetch_rate' if @debug
    puts '@app_id: ' + @app_id.inspect if @debug
    
    rate = OpenExchangeRates::Rates.new(app_id: @app_id)\
        .exchange_rate(from: @base, to: currency)
    
    puts "currency: %s rate: %s" % [currency, rate] if @debug
    
    @rates[currency.upcase.to_sym] = [rate, Time.now.to_s]
    File.write @cache_filepath, \
        {base: @base, date: @date, rates: @rates}.to_json
    rate
    
  end  

end
