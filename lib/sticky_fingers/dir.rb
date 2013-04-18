class StickyFingers::Dir < StickyFingers::File
  def ls
    values
  end

  def cd(dir, &block)
    dir += '/' unless dir =~ /\/$/
    dir = files[dir]
    dir.instance_eval(&block)
  end

  def has?(file)
    files.has_key?(file)
  end

  def []=(key, value)
    files[key] = value
  end

  def [](key)
    files[key]
  end

  def keys
    files.keys
  end

  def values
    files.values
  end

  def file? ; false ; end
  def dir?  ; true  ; end

  private
  def files
    @files ||= {}
  end
end
