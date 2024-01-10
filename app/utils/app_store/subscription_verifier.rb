# frozen_string_literal: true

# app/utils/app_store/subscription_verifier.rb
module AppStore
  class SubscriptionVerifier
    def receipt_verifier(receipt_data)
      config = CandyCheck::AppStore::Config.new(
        environment: ENV['APPSTORE_ENV'].to_sym
      )
      verifier = CandyCheck::AppStore::Verifier.new(config)
      secret = ENV['APPSTORE_SECRET']
      verifier.verify(receipt_data, secret)
    end
  end
end
