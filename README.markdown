# Codifligne
Work in progress :
An API wrapper for Stif Codifligne API

# Dependencies
Ruby >= 2.1.0

# Install
Build
```ruby
git clone git@github.com:AF83/stif-codifline-api.git
cd stif-codifline-api
gem build codifligne.gemspec
gem install -l codifligne-0.0.1.gem
```

Add to your project
```ruby
gem 'codifligne'
bundle install
```

Usage
```ruby
# Retrieve all operators
client    = Codifligne::API.new
operators = client.operators

# Retrieve operators by transport_mode
operators = client.operators(transport_mode: 'fer')

# Retrieve all line  by operator name
lines = client.lines(operator_name: 'ADP')
```

You can set timeout and override api base url globally in your config/initializers/codifligne.rb
```ruby
Codifligne::API.base_url = "https://codifligne.stif.info/rest/v1/lc/getlist"
Codifligne::API.timeout  = 50
```


# Tests
```ruby
cd stif-codifline-api
rake db:migrate RAILS_ENV=test
rspec spec/codifligne
```