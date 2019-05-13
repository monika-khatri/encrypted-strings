module Api
  module V1
    class KeyRotationsController < ::ApplicationController

      before_action :set_rotation, only: :show

      # POST /data_encrypting_keys/rotate
      def create
        job_id = KeyRotationWorker.perform_async
        if job_id.nil?
          render json: { message: DataEncryptingKey.rotation.status_message},
                 status: :unprocessable_entity
        else
          head :ok
        end
      end

      # GET /data_encrypting_keys/rotate/status
      def show
        render json: { message: @rotation.status_message }
      end

      private

      def set_rotation
        @rotation = DataEncryptingKey.rotation
      end
    end
  end
end
