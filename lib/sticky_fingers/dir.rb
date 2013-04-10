class StickyFingers::Dir < StickyFingers::FileBase
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

  def dir?
    true
  end

  private
  def files
    @files ||= {}
  end
end
