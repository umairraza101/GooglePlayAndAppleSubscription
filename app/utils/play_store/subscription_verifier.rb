# frozen_string_literal: true

# app/utils/play_store/subscription_verifier.rb
module PlayStore
  class SubscriptionVerifier
    def purchase_verifier(purchase_token, product_id)
      package_name = Rails.env.production? ? 'perci.us' : 'staging.perci.us'
      playstore_verifier.verify_subscription(package_name,
                                             product_id,
                                             purchase_token)
    end

    def playstore_verifier
      config = playstore_config
      verifier = CandyCheck::PlayStore::Verifier.new(config)
      verifier.boot!
      verifier
    end

    def playstore_config
      CandyCheck::PlayStore::Config.new(
        application_name: ENV['PLAYSTORE_APP_NAME'] || 'Perci',
        application_version: ENV['PLAYSTORE_APP_VERSION'] || '0.0.1',
        key_file: ENV['PLAYSTORE_KEY_FILE']
      )
    end
  end
end
