module V1
  class BaseController < ApplicationController
    protect_from_forgery with: :null_session
    
    before_action :authenticate_user
    
    private
    
    def authenticate_user
      header = request.headers['Authorization']
      header = header.split(' ').last if header
      
      begin
        @decoded = JWT.decode(header, Rails.application.credentials.secret_key_base)[0]
        @current_user = User.find(@decoded['user_id'])
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { errors: e.message }, status: :unauthorized
      end
    end
  end
end 