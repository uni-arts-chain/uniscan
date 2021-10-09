module WelcomeHelper
  def token_image(token)
    if token.image.present? && token.image.attached?
      if token.image.variable?
        # url_for token.image
        url_for token.image.variant(resize: "300x300", loader: { page: nil }) 
      else
        image_url("logo-uniscan")
      end
    else
      image_url("logo-uniscan")
    end
  end
end
