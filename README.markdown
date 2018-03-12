# Reflex
Work in progress :
An API wrapper for Stif Reflex API

# Dependencies
Ruby >= 2.1.0
Libmagic

# Install
Build
```ruby
git clone git@github.com:af83/stif-reflex-api.git
cd stif-reflex-api
gem build Reflex.gemspec
gem install -l Reflex-0.0.1.gem
```

Add to your project
```ruby
gem 'Reflex'
bundle install
```

Usage
```ruby

client  = Reflex::API.new
results = client.process 'getOP'
```

You can set timeout and override api base url globally in your config/initializers/Reflex.rb
```ruby
Reflex::API.base_url = "https://reflex.stif.info/ws/reflex/V1/service=getData"
Reflex::API.timeout  = 50
```

# Tests
```ruby
cd stif-reflex-api
rspec spec/Reflex
```
