require 'sticky_fingers.so'
require 'nkf'
require 'fileutils'

class StickyFingers
  require 'sticky_fingers/file'
  require 'sticky_fingers/dir'

  def self.open(filename, &block)
    sticky_fingers = StickyFingers.open_file(filename)
    if block_given?
      sticky_fingers.instance_eval &block
    else
      sticky_fingers
    end
  end

  def self.unzip(filename, basepath, options = {})
    open(filename).unzip(basepath, options)
  end

  def ls
    root.ls
  end

  def cd(dir, &block)
    root.cd(dir, &block)
  end

  def unzip(basepath = nil, options = {})
    basepath ||= './'
    list_files.sort.each do |filename|
      unless filename =~ /\/$/
        file = StickyFingers::File.new(self, filename)
        fullpath = ::File.join basepath, file.name
        dirname = ::File.dirname(fullpath)
        basename = ::File.basename(fullpath)
        ::FileUtils.mkdir_p(dirname)
        puts "unzip #{file.name} to #{fullpath}" unless options[:quiet] == true
        file.cp fullpath unless options[:dry] == true
      end
    end
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
