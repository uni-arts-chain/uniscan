class WelcomeController < ApplicationController
  def index
  end

  def hello
    render :layout => false
  end
end
