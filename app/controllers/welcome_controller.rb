class WelcomeController < ApplicationController
  def index
    @tokens = Token.eligible
      .includes(collection: [:blockchain])
      .includes(:accounts)
      .with_attached_image
      .order(created_at: :desc)
      .limit(50)

    # test
    @transfers = Transfer.joins(:token)
      .includes(token: [:accounts, collection: [:blockchain], image_attachment: :blob])
      .includes(:from, :to)
      .where("tokens.token_uri_processed=true and tokens.token_uri_err is null")
      .order("transfers.created_at desc")
      .limit(50)

    @highest_24h = Token.eligible
      .includes(collection: [:blockchain])
      .includes(:accounts)
      .with_attached_image
      .order(transfers_count_24h: :desc)
      .limit(50)

    @highest_7d = Token.eligible
      .includes(collection: [:blockchain])
      .includes(:accounts)
      .with_attached_image
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
