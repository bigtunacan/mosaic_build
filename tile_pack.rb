require 'fileutils'
require 'byebug'
require 'RMagick'
include Magick


#row = NUM_ROWS
#col = NUM_COLS
#ilg = ImageList.new
#1.upto(col) {|x| il = ImageList.new
#1.upto(row) {|y| il.push(Image.read((y + (x-1)*col).to_s + ".jpg").first)}
#ilg.push(il.append(false))}
#ilg.append(true).write("out.jpg")


def pack_images(curr_dir)
  Dir.foreach(curr_dir) do |dir|
    next if EXCLUDE_DIRS.include? dir

    if File.directory?(curr_dir + '/' + dir)
      pack_images(curr_dir + '/' + dir)
    elsif File.file?(curr_dir + '/' + dir)
      if dir.include?(".png") || dir.include?(".jpg")
        $img_list.push( Image.read(curr_dir + '/' + dir).first )
        #byebug
      end
    end
  end
end

# NOTE: Notice that this only works with the specific size
# it will need to be updated eventually
src_dir = "./out/32/Art/Symbols/Version_B"
EXCLUDE_DIRS = ['.','..']

FileUtils.remove_dir('./pack.png', true)
# TODO: the real code here...

$img_list = ImageList.new
pack_images(src_dir)
$img_list.append(true).write("pack.png")

#TODO: Fix the following line
FileUtils.rm('/Users/jseeley/Box Sync/mosaic_build/pack.png', :force => true)
FileUtils.copy('./pack.png','/Users/jseeley/Box Sync/mosaic_build/')
