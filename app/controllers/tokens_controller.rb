class TokensController < ApplicationController
  def index
    @first_token_id = 
      if params[:first_token_id].blank?
        first_token = Token
          .where(invalidated: false, token_uri_err: nil)
          .where.not(image: nil)
          .order(created_at: :desc)
          .limit(1)
          .first
        first_token.id
      else
        params[:first_token_id]
      end

    tokens = Token
      .where(invalidated: false, token_uri_err: nil)
      .where.not(image: nil)
      .where("id <= #{@first_token_id}")
      .order(created_at: :desc)

    @pagy, @tokens = pagy(tokens)

    respond_to do |format|
      format.html
      format.json {
        render json: { 
          entries: render_to_string(partial: "tokens", formats: [:html]),
          next_page_url: @pagy.page == @pagy.last ? nil : tokens_index_url(page: @pagy.next, first_token_id: @first_token_id)
        }
      }
    end
  end
end
