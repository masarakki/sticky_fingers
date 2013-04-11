require 'sticky_fingers.so'
require 'nkf'

class StickyFingers
  autoload :FileBase, 'sticky_fingers/file_base'
  autoload :Dir, 'sticky_fingers/dir'
  autoload :File, 'sticky_fingers/file'

  def self.open(filename, &block)
    sticky_fingers = StickyFingers.open_file(filename)
    if block_given?
      sticky_fingers.instance_eval &block
    else
      sticky_fingers
    end
  end

  def ls
    root.values
  end

  private
  def root
    @file_mappings ||= generate_file_mappings
  end

  def generate_file_mappings
    root = StickyFingers::Dir.new(self, '/')
    list_files.sort.each do |filename|
      mode = filename =~ /\/$/ ? :dir : :file
      target = root
      directories = filename.split('/')
      basename = directories.pop

      directories.each do |dirname|
        target["#{dirname}/"] = StickyFingers::Dir.new(self, "#{dirname}/") unless target["#{dirname}/"]
        target = target["#{dirname}/"]
      end

      case mode
      when :file
        target[basename] = StickyFingers::File.new(self, filename)
      when :dir
        target["#{basename}/"] = StickyFingers::Dir.new(self, filename)
      end
    end
    root
  end
end
