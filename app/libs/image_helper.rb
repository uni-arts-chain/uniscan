# Token image help methods
class ImageHelper

  # Download the file of image_uri.
  # Convert to image if the image_uri is a svg
  def self.download_and_convert_image(image_uri)
    tempfile = Down.download(image_uri, max_size: 50 * 1024 * 1024) # 50 MB
    content_type = tempfile.content_type

    # Convert svg to png
    if content_type.include?("svg")
      tempfile = ImageProcessing::MiniMagick
        .source(tempfile)
        .convert("png")
        .call
      content_type = "image/png"
    end

    # Convert video to gif
    if content_type.start_with?("video")
      tempfile = video_to_gif(tempfile)
      content_type = "image/gif"
    end

    # Shrink Larger Images
    ext = MIME::Types[content_type].first.extensions.first
    tempfile = ImageProcessing::MiniMagick
      .source(tempfile)
      .resize_to_limit(600, 600)
      .convert(ext)
      .strip
      .call

    [ tempfile, content_type ]
  end

  def self.video_to_gif(video_file)
    gif_file = Tempfile.new(["", ".gif"])
    `#{Rails.root.join("scripts", "vid-to-gif.sh").to_s} -f 10 -w 600 #{video.path} #{gif_file.path}`
    gif_file
  end
end
