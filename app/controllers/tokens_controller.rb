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

    @pagy, @tokens = pagy(tokens, items: 120)

    @q_string = build_q_string(params[:q])
    @stream_name = build_stream_name(params[:q])

    respond_to do |format|
      format.html
      format.json {
        render json: { 
          entries: render_to_string(partial: "tokens", formats: [:html]),
          next_page_url: @pagy.page == @pagy.last ? nil : tokens_url(page: @pagy.next, first_token_id: @first_token_id) + "&" + @q_string
        }
      }
    end
  end

  private

  def build_q_string(q)
    return "" if q.blank?

    result_arr = []
    if q["collection_blockchain_id_eq"].present?
      result_arr << "q%5Bcollection_blockchain_id_eq%5D=#{q["collection_blockchain_id_eq"]}"
    end
    if q["collection_nft_type_eq"].present?
      result_arr << "q%5Bcollection_nft_type_eq%5D=#{q["collection_nft_type_eq"]}"
    end

    return result_arr.join("&") if result_arr.length > 1
    return "" if result_arr.length == 0

    result_arr[0]
  end

  def build_stream_name(q)
    return nil if q.blank?

    result_arr = []
    if q["collection_blockchain_id_eq"].present?
      result_arr << q["collection_blockchain_id_eq"]
    else
      result_arr << "_"
    end
    if q["collection_nft_type_eq"].present?
      result_arr << q["collection_nft_type_eq"]
    else
      result_arr << "_"
    end

    return nil if result_arr == ["_", "_"]
    result_arr.join(":")
  end
  
end
