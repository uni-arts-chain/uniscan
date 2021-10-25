# The controller of the website root index view(welcome/index).
class WelcomeController < ApplicationController
  # The action method for +welcome/index+ view.
  #
  # It prepares 4 data:
  #
  # 1. The latest 50 tokens
  # 2. The latest 50 transfers
  # 3. 50 tokens with the most transfers within 24 hours
  # 4. 50 tokens with the most transfers within 7 days
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

end
