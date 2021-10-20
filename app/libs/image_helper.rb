# Token image help methods
class ImageHelper

  # Download the file of image_uri.
  # Convert to image if the image_uri is a svg
  def self.download_and_convert_image(image_uri)
    tempfile = Down.download(image_uri, max_size: 50 * 1024 * 1024) # 50 MB

    if tempfile.content_type.include?("svg")
      tempfile = ImageProcessing::MiniMagick
        .source(tempfile)
        .convert("png")
        .call
      content_type = "image/png"
    else
      content_type = tempfile.content_type
    end

    # Shrink Larger Images
      # if tempfile.size > 5 * 1024 * 1024
      # end
    tempfile = ImageProcessing::MiniMagick
      .source(tempfile)
      .resize_to_limit(600, 600)
      .strip
      .call

    [ tempfile, content_type ]
  end

end
