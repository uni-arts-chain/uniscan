class TokensController < ApplicationController
  def index
    tokens = Token
      .where(invalidated: false, token_uri_err: nil)
      .where.not(image: nil)

    if params[:first_token_id].present?
      tokens = tokens.where("id <= #{params[:first_token_id]}")
    end

    tokens = tokens.order(created_at: :desc)

    @pagy, @tokens = pagy(tokens)

    respond_to do |format|
      format.html
      format.json {
        render json: { 
          entries: render_to_string(partial: "tokens", formats: [:html]),
          next_page_url: @pagy.page == @pagy.last ? nil : tokens_index_url(page: @pagy.next, first_token_id: params[:first_token_id])
        }
      }
    end
  end
end
