

class Etherscan
  # https://api.etherscan.io/api?module=account&action=txlist&address=0xa7d8d9ef8d8ce8992df33d8b8cf4aebabd5bd270&startblock=0&endblock=99999999&page=1&offset=1&sort=asc&apikey=xxx
  # https://api.etherscan.io/api?module=account&action=txlistinternal&address=0x0b2a13bc4a09bf1ee822964c3619f79791719ec0&startblock=0&endblock=99999999&page=1&offset=1&sort=asc&apikey=xxx
  def self.get_contract_creation_transacton(address)
    sleep 1

    contract_creation_request_url = 
      "https://api-cn.etherscan.com/api" +
        "?module=account" +
        "&action=txlist" +
        "&address=#{address}" +
        "&startblock=0" +
        "&endblock=99999999" +
        "&page=1" +
        "&offset=1" +
        "&sort=asc" +
        "&apikey=#{ENV['ETHERSCAN_APIKEY']}"
    puts contract_creation_request_url
    response = Faraday.get contract_creation_request_url
    body = JSON.parse response.body
    result = body["result"]
    if result.nil? || result.class != Array || result.length == 0

      tx = get_contract_creation_internal_transacton(address)

    else

      tx = result[0]
      # if it is not the creation transaction, find in internal tx list
      if tx["to"].present? && tx["contractAddress"].blank?
        tx = get_contract_creation_internal_transacton(address)
      end

    end

    tx
  end

  def self.get_contract_creation_internal_transacton(address)
    sleep 1
    contract_creation_request_url = 
      "https://api-cn.etherscan.com/api" +
        "?module=account" +
        "&action=txlistinternal" +
        "&address=#{address}" +
        "&startblock=0" +
        "&endblock=99999999" +
        "&page=1" +
        "&offset=1" +
        "&sort=asc" +
        "&apikey=#{ENV['ETHERSCAN_APIKEY']}"
    puts contract_creation_request_url
    response = Faraday.get contract_creation_request_url
    body = JSON.parse response.body
    tx = body["result"][0]
  end
end


