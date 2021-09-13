class TokensController < ApplicationController
  def index
    params[:q] = { "s" => "created_at desc" } if params[:q].nil? 
    params[:q]["s"] = "created_at desc" if params[:q]["s"].blank?

    @q = Token.ransack(params[:q])
    tokens = @q.result
      .where(invalidated: false, token_uri_err: nil)
      .where.not(image: nil)

    @first_token_id = 
      if params[:first_token_id].blank?
        first_token = tokens.limit(1).first
        first_token&.id
      else
        params[:first_token_id]
      end

    if @first_token_id
      if params[:q]["s"].include?(" desc")
        tokens = tokens 
          .where("tokens.id <= #{@first_token_id}")
      else
        tokens = tokens
          .where("tokens.id >= #{@first_token_id}")
      end
    end

    @pagy, @tokens = pagy(tokens, items: 36)

    @q_string = build_q_string(params[:q])
    if @pagy.page == @pagy.last
      @next_page_url = nil
    else
      @next_page_url = 
        tokens_url(page: @pagy.next, first_token_id: @first_token_id) \
        + "&" \
        + @q_string
    end
    @stream_sub_name = build_stream_sub_name(params[:q])

    respond_to do |format|
      format.html
      format.json {
        render json: { 
          entries: render_to_string(partial: "tokens", formats: [:html]),
          next_page_url: @next_page_url
        }
      }
    end
  end

  def show
    @token = Token.find(params[:id])
  end

  private

  def build_q_string(q)
    return "" if q.blank?

    result_arr = []
    if q["collection_blockchain_id_eq"].present?
      result_arr << "q[collection_blockchain_id_eq]=#{q["collection_blockchain_id_eq"]}"
    end
    if q["collection_nft_type_eq"].present?
      result_arr << "q[collection_nft_type_eq]=#{q["collection_nft_type_eq"]}"
    end
    if q["name_or_description_cont"].present?
      result_arr << "q[name_or_description_cont=#{q["name_or_description_cont"]}"
    end
    if q["s"].present?
      result_arr << "q[s]=#{q["s"]}"
    end

    return "" if result_arr.length == 0

    if result_arr.length > 1
      result_arr.join("&") 
    else
      result_arr[0]
    end
  end

  # tokens:stream_sub_name
  def build_stream_sub_name(q)
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
