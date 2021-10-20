require 'fileutils'

unless File.exists?("./storage")
  Dir.mkdir "./storage"
end
Dir.glob("../storage/**/*") do |file|
  unless File.directory?(file)
    FileUtils.cp file, "./storage"
  end
end
