require 'sticky_fingers.so'
require 'nkf'

class StickyFingers
  def self.open(filename, &block)
    sticky_fingers = StickyFingers.open_file(filename)
    block.call(sticky_fingers)
  end

  def ls
    list_files.select {|x| x.match(/\/$/) or !x.include?('/') }.map {|x| NKF.nkf('-w', x) }
  end
end
