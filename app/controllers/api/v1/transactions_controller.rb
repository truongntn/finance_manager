module Api
  module V1
    class TransactionsController < BaseController
      def index
        @bank_account = @current_user.bank_accounts.find(params[:bank_account_id])
        @transactions = @bank_account.transactions
        render json: @transactions
      rescue ActiveRecord::RecordNotFound
        render json: { errors: ['Bank account not found'] }, status: :not_found
      end
      
      def show
        @bank_account = @current_user.bank_accounts.find(params[:bank_account_id])
        @transaction = @bank_account.transactions.find(params[:id])
        render json: @transaction
      rescue ActiveRecord::RecordNotFound
        render json: { errors: ['Transaction not found'] }, status: :not_found
      end
      
      def create
        @bank_account = @current_user.bank_accounts.find(params[:bank_account_id])
        @transaction = @bank_account.transactions.build(transaction_params)
        
        if @transaction.save
          render json: @transaction, status: :created
        else
          render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { errors: ['Bank account not found'] }, status: :not_found
      end
      
      def update
        @bank_account = @current_user.bank_accounts.find(params[:bank_account_id])
        @transaction = @bank_account.transactions.find(params[:id])
        
        if @transaction.update(transaction_params)
          render json: @transaction
        else
          render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { errors: ['Transaction not found'] }, status: :not_found
      end
      
      def destroy
        @bank_account = @current_user.bank_accounts.find(params[:bank_account_id])
        @transaction = @bank_account.transactions.find(params[:id])
        @transaction.destroy
        head :no_content
      rescue ActiveRecord::RecordNotFound
        render json: { errors: ['Transaction not found'] }, status: :not_found
      end
      
      private
      
      def transaction_params
        params.require(:transaction).permit(:amount, :transaction_type, :category, :description, :date)
      end
    end
  end
end 