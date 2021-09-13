class CollectionsController < ApplicationController
  def index
  end

  def show
    @collection = Collection.find(params[:id])
    @pagy, @tokens= pagy(@collection.tokens, items: 24)
  end
end
