class TokensController < ApplicationController
  def index
    @q = Token.ransack(params[:q])
    query = @q.result
      .where(invalidated: false, token_uri_err: nil)
      .where.not(image: nil)
      .order(created_at: :desc)

    @first_token_id = 
      if params[:first_token_id].blank?
        first_token = query.limit(1).first
        first_token.id
      else
        params[:first_token_id]
      end

    tokens = query
      .where("tokens.id <= #{@first_token_id}")

    @pagy, @tokens = pagy(tokens)

    @query_string = request.query_string.split("&").select do |q|
      q.start_with?("q%5B")
    end.join("&")

    respond_to do |format|
      format.html
      format.json {
        render json: { 
          entries: render_to_string(partial: "tokens", formats: [:html]),
          next_page_url: @pagy.page == @pagy.last ? nil : tokens_url(page: @pagy.next, first_token_id: @first_token_id) + "&" + @query_string
        }
      }
    end
  end
end
