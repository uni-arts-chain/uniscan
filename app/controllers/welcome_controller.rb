class WelcomeController < ApplicationController
  def index
    @tokens = Token.eligible
      .order(created_at: :desc)
      .limit(50)

    @transfers = Transfer.order(created_at: :desc)
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
    render :layout => false
  end
end
