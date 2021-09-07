class WelcomeController < ApplicationController
  def index
    @tokens = Token
      .where(invalidated: false, token_uri_err: nil)
      .where.not(image: nil)
      .order(created_at: :desc)
  end
end
