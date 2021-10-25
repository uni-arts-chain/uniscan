# The controller of the accounts views.
class AccountsController < ApplicationController
  # The action method for +accounts/show+ view. 
  #
  # Show an account with its collections and tokens.
  # No pagination now.
  def show
    @account = Account.find(params[:id])
  end
end
