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
rake codifligne:install:migrations
rake db:migrate
rake codifligne:populate
```

Usage
```ruby
# Retrieve lines from a operator
operators = Codifligne::Operator.take
lines     = operator.lines

# Retrieve operators from a line
line      = Codifligne::Line.take
operators = line.operators
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