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
end
