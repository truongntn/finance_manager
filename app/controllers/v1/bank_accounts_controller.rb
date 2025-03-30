module V1
  class BankAccountsController < BaseController
    def index
      @bank_accounts = @current_user.bank_accounts
      render json: @bank_accounts
    end
    
    def show
      @bank_account = @current_user.bank_accounts.find(params[:id])
      render json: @bank_account
    rescue ActiveRecord::RecordNotFound
      render json: { errors: ['Bank account not found'] }, status: :not_found
    end
    
    def create
      @bank_account = @current_user.bank_accounts.build(bank_account_params)
      
      if @bank_account.save
        render json: @bank_account, status: :created
      else
        render json: { errors: @bank_account.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    def update
      @bank_account = @current_user.bank_accounts.find(params[:id])
      
      if @bank_account.update(bank_account_params)
        render json: @bank_account
      else
        render json: { errors: @bank_account.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { errors: ['Bank account not found'] }, status: :not_found
    end
    
    def destroy
      @bank_account = @current_user.bank_accounts.find(params[:id])
      @bank_account.destroy
      head :no_content
    rescue ActiveRecord::RecordNotFound
      render json: { errors: ['Bank account not found'] }, status: :not_found
    end
    
    private
    
    def bank_account_params
      params.require(:bank_account).permit(:name, :account_type, :balance, :currency)
    end
  end
end 