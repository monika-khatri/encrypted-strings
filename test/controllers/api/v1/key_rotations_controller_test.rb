require 'test_helper'
module Api
  module V1
    class KeyRotationsControllerTest < ActionController::TestCase

      def setup
        DataEncryptingKey.generate!(primary: true) if DataEncryptingKey.primary.nil?
        Sidekiq::Testing.disable!
        Sidekiq.redis(&:flushdb)
      end

      def after_teardown
        Sidekiq::Worker.clear_all
        Sidekiq.redis(&:flushdb)
        super
      end

      test "POST #create queues KeyRotationWorker" do
        post :create
        assert_response :success
      end

      test "POST #create returns unprocessable_entity" do
        KeyRotationWorker.perform_async

        post :create
        assert_response :unprocessable_entity

        json = JSON.parse(response.body)
        assert_equal "Key rotation has been queued", json["message"]
      end

      test "get #show returns no rotation in progress" do
        get :show

        assert_response :success

        json = JSON.parse(response.body)
        assert_equal "No key rotation queued or in progress", json["message"]
      end

      test "get #show returns queued" do
        KeyRotationWorker.perform_async
        get :show

        assert_response :success

        json = JSON.parse(response.body)
        assert_equal "Key rotation has been queued", json["message"]
      end
    end
  end
end
