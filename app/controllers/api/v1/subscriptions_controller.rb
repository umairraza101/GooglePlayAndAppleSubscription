# frozen_string_literal: true

# app/controllers/api/v1/subscriptions_controller.rb
module Api
  module V1
    class SubscriptionsController < ApplicationController
      # PUT /api/v1/subscriptions/playstore
      def playstore
        notification = if params['message']['data'].present?
                         JSON.parse(Base64.decode64(params['message']['data']), symbolize_names: true)
                       else
                         { purchaseToken: params[:purchaseToken], subscriptionId: params[:productId] }
                       end
        receipt = PlayStore::SubscriptionVerifier.new.purchase_verifier(notification[:purchaseToken],
                                                                        notification[:subscriptionId])
        if receipt.instance_of?(CandyCheck::PlayStore::Subscription)
          # check_playstore_receipt(receipt) # A method to deal with data received from the AppStore
          render json: receipt, status: :ok
        elsif receipt.instance_of?(CandyCheck::PlayStore::VerificationFailure)
          render json: receipt, status: :bad_request
        end
      end

      # PUT /api/v1/subscriptions/appstore
      def appstore
        # receipt_data come from params
        receipt = AppStore::SubscriptionVerifier.new.receipt_verifier(receipt_data)
        if receipt.instance_of?(CandyCheck::AppStore::Receipt)
          # check_appstore_receipt(receipt) # A method to deal with data received from AppStore
          render json: receipt, status: :ok
        elsif receipt.instance_of?(CandyCheck::AppStore::VerificationFailure)
          render json: { code: receipt.code, message: receipt.message },
                 status: :bad_request
        end
      end
    end
  end
end
