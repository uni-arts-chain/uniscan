class WelcomeController < ApplicationController
  def index
    @tokens = Token.where(
      "token_uri_err is null and " + 
      "TRIM(token_uri) != '' and " +
      "image is not null and " + 
      "TRIM(image) != ''"
    ).order(created_at: :asc).offset(23).limit(50)
  end

  def hello
    render :layout => false
  end
end
