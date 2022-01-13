require "graphql/client"
require "graphql/client/http"

module TGAPI2
  # Configure GraphQL endpoint using the basic HTTP network adapter.
  HTTP = GraphQL::Client::HTTP.new("https://api.thegraph.com/subgraphs/name/amxx/eip721-subgraph") do
    def headers(context)
      # Optionally set any HTTP headers
      { "User-Agent": "Uniscan" }
    end
  end  

  # Fetch latest schema on init, this will make a network request
  Schema = GraphQL::Client.load_schema(HTTP)

  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
end

InitTransfersQuery = TGAPI2::Client.parse <<-'GRAPHQL'
  query($first: Int) {
    transfers(first: $first, orderBy: timestamp, orderDirection: asc) {
      token {
        identifier
        uri
        registry {
          id
          supportsMetadata
          name
          symbol
        }
      }
      transaction {
        id
        blockNumber
      }
      timestamp
      from {
        id
      }
      to {
        id
      }
    }
  }
GRAPHQL

TransfersQuery = TGAPI2::Client.parse <<-'GRAPHQL'
  query($first: Int, $last_timestamp: BigInt) {
    transfers(first: $first, where: {timestamp_gt: $last_timestamp}, orderBy: timestamp, orderDirection: asc) {
      token {
        identifier
        uri
        registry {
          id
          supportsMetadata
          name
          symbol
        }
      }
      transaction {
        id
        blockNumber
      }
      timestamp
      from {
        id
      }
      to {
        id
      }
    }
  }
GRAPHQL
TRANSFERS_QUERY_BATCH_SIZE = 1000
