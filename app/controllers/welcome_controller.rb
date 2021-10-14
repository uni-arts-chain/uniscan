class WelcomeController < ApplicationController
  def index
    @tokens = Token.eligible
      .order(created_at: :desc)
      .limit(50)

    # test
    @transfers = Transfer.joins(:token)
      .where("tokens.token_uri_processed=true and tokens.token_uri_err is null")
      .order("transfers.created_at desc")
      .limit(50)

    @highest_24h = Token.eligible
      .order(transfers_count_24h: :desc)
      .limit(50)

    @highest_7d = Token.eligible
      .order(transfers_count_7d: :desc)
      .limit(50)

    render layout: "welcome"
  end

  def hello
    @tokens = Token.eligible
      .order(created_at: :desc)
      .limit(50)
  end
end
