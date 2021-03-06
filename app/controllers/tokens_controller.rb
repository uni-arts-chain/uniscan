# The controller of the token views.
class TokensController < ApplicationController
  # The action method for +tokens/index+ view. Prepare paged token list by condiction.
  # 
  # +Push+ function: If the +Push+ switch is turned on, the tokens index page will start a websocket, and then wait for the server to push the newly discovered NFTs. Once there is a new NFT, it will be displayed at the top of the page. When the +Push+ is turned on, the sorting of the page will be locked to +created_at desc+.
  #
  # Default sort by +created_at desc+.  
  # +Push+ function is disabled by default.   
  # 36 token per page.
  def index
    params[:q] = { "s" => "created_at desc" } if params[:q].nil? 
    params[:q]["s"] = "created_at desc" if params[:q]["s"].blank?
    
    @push = params[:push].blank? ? false : params[:push] == "true"

    @q = Token.ransack(params[:q])
    tokens = @q.result
      .eligible
      .includes(collection: [:blockchain])
      .includes(:accounts)
      .with_attached_image
      .where(token_uri_err: nil)
      .where.not(image_uri: nil)

    @pagy, @tokens = pagy(tokens, items: 36)

    @q_string = build_q_string(params[:q])
    if @pagy.page == @pagy.last
      @next_page_url = nil
    else
      @next_page_url = 
        tokens_url(page: @pagy.next) \
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

  # The action method for +tokens/show+ view.
  # Show a token with its metadata
  def show
    @token = Token.find(params[:id])
  end

  def show2
    collection = Collection.find_by(contract_address: params[:address])
    @token = Token.find_by(collection: collection, token_id_on_chain: params[:token_id])
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
