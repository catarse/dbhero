Rails.application.routes.draw do

  mount Dbhero::Engine => "/dbhero", as: 'dbhero'
end
