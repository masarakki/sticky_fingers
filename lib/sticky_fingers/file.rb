class StickyFingers::File
  def initialize(archive, filename)
    @archive = archive
    @filename = filename
  end

  def name
    NKF.nkf('-w', @filename)
  end

  def file? ; true  ; end
  def dir?  ; false ; end
end
