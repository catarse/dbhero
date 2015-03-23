# DBHero

DBHero is a webui to create fast datasets from your database.


## installation

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