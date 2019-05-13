module Api
  module V1
    class EncryptedStringsController < ::ApplicationController

      before_action :load_encrypted_string, only: [:show, :destroy]

      # POST /encrypted_strings
      def create
        @encrypted_string = EncryptedString.new(value: encrypted_string_params[:value])
        if @encrypted_string.save
          render json: { token: @encrypted_string.token }
        else
          render json: { message: @encrypted_string.errors.full_messages.to_sentence},
                 status: :unprocessable_entity
        end
      end

      # GET /encrypted_strings/:token
      def show
        render json: { value: @encrypted_string.value }
      end

      # DELETE /encrypted_strings/:token
      def destroy
        @encrypted_string.destroy!
        head :ok
      end

      private

      def load_encrypted_string
        @encrypted_string = EncryptedString.find_by(token: params[:token])
        if @encrypted_string.nil?
          render json: { messsage: "No entry found for token #{params[:token]}" },
                 status: :not_found
        end
      end

      def encrypted_string_params
        params.require(:encrypted_string).permit(:value)
      end
    end
  end
end
