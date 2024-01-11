# frozen_string_literal: true

# app/utils/play_store/subscription_verifier.rb
module PlayStore
  class SubscriptionVerifier
    attr_reader :authorization

    def purchase_verifier(purchase_token, product_id)
      verify(purchase_token, product_id)
    end

    def verify(purchase_token, product_id)
      playstore_verifier.verify_subscription_purchase(package_name: playstore_config[:package_name],
                                                      subscription_id: product_id,
                                                      token: purchase_token)
    end

    def playstore_verifier
      authorization = CandyCheck::PlayStore.authorization(playstore_config[:key_file])

      CandyCheck::PlayStore::Verifier.new(authorization:)
    end

    def package_name
      playstore_config[:package_name]
    end

    def playstore_config
      {
        application_name: (ENV['PLAYSTORE_APP_NAME'] || 'Perci'), # ;PLAYSTORE_APP_VERSION=0.0.1;PLAYSTORE_KEY_FILE=/tmp/google-playstore-key-file.json;PLAYSTORE_PACKAGE_NAME=perci.us,
        application_version: (ENV['PLAYSTORE_APP_VERSION'] || '0.0.1'),
        key_file: ENV['PLAYSTORE_KEY_FILE'],
        package_name: (ENV['PLAYSTORE_PACKAGE_NAME'] || (Rails.env.production? ? 'perci.us' : 'staging.perci.us'))
      }
    end
  end
end
