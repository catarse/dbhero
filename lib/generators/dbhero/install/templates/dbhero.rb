Dbhero.configure do |config|
  # Authenticate method to use on private pages
  # if you are using devise you can keep the "authenticate_user!"
  config.authenticate_method = :authenticate_user!

  # Method to get the current user authenticated on your app
  # if you are using devise you can keep the "current_user"
  config.current_user_method = :current_user

  # String representation for user
  # when creating a dataclip just save on user field
  config.user_representation = :email

  # Google drive integration, uncomment to use ;)
  # you can get you google api credentials here:
  # https://developers.google.com/drive/web/auth/web-server
  #
  # config.google_api_id = 'GOOGLE_API_ID'
  # config.google_api_secret = 'GOOGLE_API_SECRET'
end


