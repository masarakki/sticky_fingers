require 'nkf'

class StickyFingers::FileBase
  def initialize(base, filename)
    @base = base
    @filename = filename
  end

  def name
    NKF.nkf('-w', @filename)
  end

  def file?
    false
  end

  def dir?
    false
  end
end
