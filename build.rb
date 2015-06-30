require 'fileutils'
require 'byebug'
require 'RMagick'
include Magick

src_dir = "./Art"
EXCLUDE_DIRS = ['.','..']

def dirs(curr_dir, size)

  Dir.foreach(curr_dir) do |dir|
    next if EXCLUDE_DIRS.include? dir

    if File.directory?(curr_dir + '/' + dir)
      dirs(curr_dir + '/' + dir, size)
    elsif File.file?(curr_dir + '/' + dir)
      if dir.include?(".png") || dir.include?(".jpg")
        pic = ImageList.new(curr_dir + '/' + dir)

        if ["-scale"].include? ARGV[0]
          pic = pic.scale(size)
        else
          pic = pic.resize_to_fit(size)
        end

        if $scaled
          size_dir = size.to_s.gsub(".", "_")
          out = Dir.pwd + '/' + curr_dir.sub(/\./, "out/#{size_dir}")
        else
          out = Dir.pwd + '/' + curr_dir.sub(/\./, "out/#{size}")
        end
        unless File.directory?(out)
          FileUtils.mkpath(out)
        end

        pic.write(out + '/' + dir)
      end
    end
  end
end

# Old method just output to a few preset sizes
# RESOLUTIONS = {:small => 32, :medium => 64, :large => 128}
# FileUtils.remove_dir('./out', true)

# RESOLUTIONS.each do |key, value|
#   dirs src_dir, value
# end

# Now you just pass the target sizes as extra args
# ruby build.rb 32 64 128
# if you pass the -scale option image uses a percent scale
#
# ruby build.rb -scale .32
# would scale to 32% of the original
# otherwise it sizes to fit by default
# width will be honored; height will be scaled
FileUtils.remove_dir('./out', true)
$scaled = ["-scale"].include?(ARGV[0])? true : false

# [1..(ARGV.length-1)].each do |i|
ARGV.each do |value|
  next if value =~ /-/

  dirs src_dir, value.to_i unless $scaled
  dirs src_dir, value.to_f if $scaled
end

# FileUtils.remove_dir('/Users/joieyseeley/Box Sync/mosaic_build/out/', true)
FileUtils.cp_r('./out','/Users/jseeley/Box Sync/mosaic_build/', :remove_destination => true)
