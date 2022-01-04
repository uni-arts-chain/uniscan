# Token image help methods
class ImageHelper

  # Download the file of image_uri. If it is not a image, try to convert it into a image 
  #
  # Convert to png if the image_uri is a svg.
  # Convert to gif if the image_uri is a video.
  #
  # resize image size to 600x600.
  # keep the aspect ratio.
  #
  # It depends on the +imagemagick+ and +ffmpeg+.
  # @param image_uri [String] the url of the image.
  # @return [Tempfile, String, String] the file, the content type, and the original
  # content type.
  def self.download_and_convert_image(image_uri)
    ori_tempfile, ori_content_type = if image_uri.start_with?("data:")
      puts "0-------------"
      to_image_file(image_uri)
    else
      if image_uri.split("?").first.downcase.end_with?(".mp4")
        raise "Wrong content_type for #{image_uri}"
      end

      puts "1-------------"
      ori_tempfile = Down.download(image_uri, max_size: 50 * 1024 * 1024) # 50 MB
      puts "2-------------"
      ori_content_type = ori_tempfile.content_type
      [ori_tempfile, ori_content_type]
    end

    if ori_content_type == "application/octet-stream" || ori_content_type.start_with?("video")
      raise "Wrong content_type for #{image_uri}"
    else
      tempfile, content_type = convert(ori_tempfile, ori_content_type)
      [ tempfile, content_type, ori_content_type ]
    end


  end

  def self.to_image_file(image_uri)
    name = Digest::SHA1.hexdigest(image_uri)
    filename, content_type, data = 
      if image_uri.start_with?("data:image/svg+xml;base64,")
        ["#{name}.svg", "image/svg+xml", image_uri[26..]]
      elsif image_uri.start_with?("data:image/gif;base64,")
        ["#{name}.gif", "image/gif", image_uri[22..]]
      elsif image_uri.start_with?("data:image/jpg;base64,")
        ["#{name}.jpg", "image/jpeg", image_uri[22..]]
      elsif image_uri.start_with?("data:image/jpeg;base64,")
        ["#{name}.jpg", "image/jpeg", image_uri[23..]]
      elsif image_uri.start_with?("data:image/png;base64,")
        ["#{name}.png", "image/png", image_uri[22..]]
      else
        raise "Not support data, #{image_uri.split(",").first}"
      end

    dir = Rails.root.join("tmp", "token_images")
    FileUtils.mkdir(dir) unless File.exists?(dir)
    File.open(dir.join(filename), 'wb') do |f|
      f.write(Base64.decode64(data))
    end

    [File.open(dir.join(filename)), content_type]
  end

  # Convert file
  #
  # 1. svg to png
  # 2. video to gif
  # 3. resize to 600x600 without changing the aspect ratio.
  def self.convert(tempfile, content_type)
    puts "c3------------- #{content_type}"
    # Convert svg to png
    if content_type.include?("svg")

      puts "c4-------------"
      tempfile = svg_to_png(tempfile)
      content_type = "image/png"

    # Convert video to gif
    elsif content_type.start_with?("video")

      puts "c5-------------"
      tempfile = video_to_gif(tempfile)
      content_type = "image/gif"

    end

    if content_type != "image/gif"
      # Shrink Larger Images
      puts "c6-------------"
      ext = MIME::Types[content_type].first.extensions.first
      tempfile = ImageProcessing::MiniMagick
        .source(tempfile)
        .resize_to_limit(600, 600)
        .convert(ext)
        .strip
        .call
    end

    [ tempfile, content_type ]
  end

  # svg to png converter
  #
  # @param svg_file [Tempfile] the svg file to convert
  # @return [Tempfile]
  def self.svg_to_png(svg_file)
    ImageProcessing::MiniMagick
      .source(svg_file)
      .convert("png")
      .call
  end

  # video to gif converter.
  #
  # @param video_file [Tempfile] the video file to convert
  # @return [Tempfile]
  def self.video_to_gif(video_file)
    gif_file = Tempfile.new(["", ".gif"])
    `#{Rails.root.join("scripts", "vid-to-gif.sh").to_s} -f 10 -w 600 #{video_file.path} #{gif_file.path}`
    gif_file
  end
end
