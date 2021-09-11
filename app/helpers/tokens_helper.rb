module TokensHelper
  def bg_of_blockchain(token)
    if token.blockchain.name == "Ethereum"
      "bg-ethereum"
    elsif token.blockchain.name == "Darwinia"
      "bg-darwinia"
    else
      ""
    end
  end

  def short_address(address)
    len = address.length
    "#{address[0...6]}...#{address[len-4...len]}"
  end

  # need stream only in
  #   1. empty q string
  #   or
  #   1. sort by created_at desc
  #   2. name_or_description_cont is blank
  def stream_needed?(q_string)
    q = Rack::Utils.parse_nested_query(q_string)
    return true if q["q"].nil?
    q["q"]["s"] == "created_at desc" && q["q"]["name_or_description_cont"].blank?
  end

end
