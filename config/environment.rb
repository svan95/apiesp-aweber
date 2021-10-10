# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ENV['CLIENT_ID'] = "9QZvwIA5OByUpahspsoXCPyaoMGGaAeH"
ENV['CLIENT_SECRET_ID'] = "J5c43SWICYomXcYEnFs0NbmmhtKQW9bM"
ENV['REDIS_URL'] = "redis://127.0.0.1:6379/0"