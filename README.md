# DBHero [![Build Status](https://travis-ci.org/catarse/dbhero.svg?branch=master)](https://travis-ci.org/catarse/dbhero) [![Code Climate](https://codeclimate.com/github/catarse/dbhero/badges/gpa.svg)](https://codeclimate.com/github/catarse/dbhero) 

DBHero is a simple and elegant web interface to extract data clips from your app database. just plug and play ;)

tested stack:
- PostgresSQL
- Ruby 2+
- Rails 4.1+

![Dbhero](http://i.imgur.com/k6pMWJ2.gif)


## installation


include in your Gemfile: 

```ruby
gem 'dbhero', '~> 1.0.0'
```

then run:

	rails g dbhero:install

This will create an initializer in ```config/initializers/dbhero.rb```
Take a look in this initializer to tweak the default attributes.

and add on your routes file:
```ruby
 mount Dbhero::Engine => "/dbhero", as: :dbhero
```
run server and open ```http://localhost:3000/dbhero``` 


## Configurations

On initializer ```config/initializers/dbhero.rb``` we can add the following configurations

```ruby
Dbhero.configure do |config|
  # if you are using devise you can keep the "authenticate_user!"
  config.authenticate = true

  # Method to get the current user authenticated on your app
  # if you are using devise you can keep the "current_user"
  config.current_user_method = :current_user

  # Custom authentication condition hover current_user_method
  config.custom_user_auth_condition = lambda do |user|
    user.admin?
  end

  # String representation for user
  # when creating a dataclip just save on user field
  config.user_representation = :email

  # Google drive integration, uncomment to use ;)
  # you can get you google api credentials here:
  # https://developers.google.com/drive/web/auth/web-server
  # google drive callback url -> /dbhero/dataclips/drive
  config.google_api_id = 'GOOGLE_API_ID'
  config.google_api_secret = 'GOOGLE_API_SECRET'
end

```


This project rocks and uses MIT-LICENSE.
