Gem::Specification.new do |s|
  s.name = 'justexchangerates'
  s.version = '0.4.0'
  s.summary = 'Fetches the latest exchange rates using ' + 
      'the open_exchange_rates gem.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/justexchangerates.rb']
  s.add_runtime_dependency('dynarex-password', '~> 0.2', '>=0.2.0')  
  s.add_runtime_dependency('chronic_duration', '~> 0.10', '>=0.10.6')  
  s.add_runtime_dependency('open_exchange_rates', '~> 0.5', '>=0.5.1')  
  s.signing_key = '../privatekeys/justexchangerates.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/justexchangerates'
end
