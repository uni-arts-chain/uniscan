# The controller of the collections views.
class CollectionsController < ApplicationController
  # The action method for +collections/show+ view. 
  #
  # Show a collection with its tokens.
  # 24 tokens per page.
  def show
    @collection = Collection.find(params[:id])
    @pagy, @tokens= pagy(@collection.tokens, items: 24)
  end

  def show2
    @collection = Collection.find_by_contract_address(params[:address])
    @pagy, @tokens= pagy(@collection.tokens, items: 24)
  end
end
