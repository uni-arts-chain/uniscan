require "graphql/client"
require "graphql/client/http"

module TGAPI
  # Configure GraphQL endpoint using the basic HTTP network adapter.
  HTTP = GraphQL::Client::HTTP.new("https://api.thegraph.com/subgraphs/name/wighawag/eip721-subgraph") do
    def headers(context)
      # Optionally set any HTTP headers
      { "User-Agent": "Uniscan" }
    end
  end  

  # Fetch latest schema on init, this will make a network request
  Schema = GraphQL::Client.load_schema(HTTP)

  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
end

AllQuery = TGAPI::Client.parse <<-'GRAPHQL'
  query {
    all(id: "all") {
      numTokenContracts
      numTokens
    }
  }
GRAPHQL

InitTokenContractsQuery = TGAPI::Client.parse <<-'GRAPHQL'
  query($first: Int) {
    tokenContracts(first: $first, orderBy: id, orderDirection: asc) {
      id
      name
      symbol
      supportsEIP721Metadata
    }
  }
GRAPHQL

TokenContractsQuery = TGAPI::Client.parse <<-'GRAPHQL'
  query($first: Int, $last_id: ID) {
    tokenContracts(first: $first, where: { id_gt: $last_id }, orderBy: id, orderDirection: asc) {
      id
      name
      symbol
      supportsEIP721Metadata
    }
  }
GRAPHQL

InitTokensQuery = TGAPI::Client.parse <<-'GRAPHQL'
  query($first: Int) {
    tokens(first: $first, orderBy: mintTime, orderDirection: asc) {
      id
      tokenURI
      owner {
        id
      }
      mintTime
    }
  }
GRAPHQL

TokensQuery = TGAPI::Client.parse <<-'GRAPHQL'
  query($first: Int, $last_mint_time: BigInt) {
    tokens(first: $first, where: { mintTime_gt: $last_mint_time }, orderBy: mintTime, orderDirection: asc) {
      id
      tokenURI
      owner {
        id
      }
      mintTime
    }
  }
GRAPHQL

TOKEN_CONTRACTS_QUERY_BATCH_SIZE = 1000
TOKENS_QUERY_BATCH_SIZE = 1000
