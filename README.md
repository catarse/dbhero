# DBHero [![Build Status](https://travis-ci.org/catarse/dbhero.svg?branch=master)](https://travis-ci.org/catarse/dbhero) [![Code Climate](https://codeclimate.com/github/catarse/dbhero/badges/gpa.svg)](https://codeclimate.com/github/catarse/dbhero) 

DBHero is a webui to create fast datasets from your database.

![Dbhero](http://i.imgur.com/k6pMWJ2.gif)


## installation

#### under development !!!!

include in your Gemfile: 

```ruby
gem 'dbhero'
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


This project rocks and uses MIT-LICENSE.
