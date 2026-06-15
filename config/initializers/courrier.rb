Courrier.configure do |config|
  config.email = {
    provider: "logger"
  }

  config.from = "hello@example.com"

  config.subscriber = {
    provider: "buttondown",
    api_key: Rails.application.credentials.dig(:buttondown, :api_key)
  }
end
