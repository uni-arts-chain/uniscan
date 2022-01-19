class ApplicationController < ActionController::Base
  include Pagy::Backend

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
