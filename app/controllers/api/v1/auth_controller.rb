module Api
  module V1
    class AuthController < ApplicationController
      def register
        user = User.new(user_params)
        
        if user.save
          token = generate_token(user)
          render json: { token: token, user: user.as_json(except: :password_digest) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
      
      def login
        user = User.find_by(email: params[:email])
        
        if user&.authenticate(params[:password])
          token = generate_token(user)
          render json: { token: token, user: user.as_json(except: :password_digest) }
        else
          render json: { errors: ['Invalid email or password'] }, status: :unauthorized
        end
      end
      
      private
      
      def user_params
        params.require(:user).permit(:email, :password, :first_name, :last_name)
      end
      
      def generate_token(user)
        JWT.encode(
          { user_id: user.id, exp: 24.hours.from_now.to_i },
          Rails.application.credentials.secret_key_base
        )
      end
    end
  end
end 