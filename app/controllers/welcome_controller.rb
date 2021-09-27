class WelcomeController < ApplicationController
  def index
    @tokens = Token.eligible
      .order(created_at: :desc)
      .limit(50)

    @transfers = Transfer.order(created_at: :desc)
      .limit(50)

    @highest_24h = Token.eligible
      .where('created_at > ?', 1024.hours.ago)
      .order(transfers_count: :desc)
      .limit(50)

    @highest_7d = Token.eligible
      .where('created_at > ?', 7.days.ago)
      .order(transfers_count: :desc)
      .limit(50)

    puts @highest_7d.count
  end

  def hello
    render :layout => false
  end
end
