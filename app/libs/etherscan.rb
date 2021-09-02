

class Etherscan
  # https://api.etherscan.io/api?module=account&action=txlist&address=0xa7d8d9ef8d8ce8992df33d8b8cf4aebabd5bd270&startblock=0&endblock=99999999&page=1&offset=1&sort=asc&apikey=CQZEXX84G6AQ5R8AZCII626EA43VPNJEEU
  def self.get_contract_creation_transacton(address)
    contract_creation_request_url = 
      "https://api.etherscan.io/api" +
        "?module=account" +
        "&action=txlist" +
        "&address=#{address}" +
        "&startblock=0" +
        "&endblock=99999999" +
        "&page=1" +
        "&offset=1" +
        "&sort=asc" +
        "&apikey=CQZEXX84G6AQ5R8AZCII626EA43VPNJEEU"
    response = Faraday.get contract_creation_request_url
    body = JSON.parse response.body
    body["result"][0]
  end

end


