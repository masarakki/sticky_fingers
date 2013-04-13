class StickyFingers::File
  def initialize(archive, filename)
    @archive = archive
    @filename = filename
  end

  def name
    NKF.nkf('-w', @filename)
  end

  def content
    @content ||= begin
                   open
                   content = read
                   close
                   content
                 end
  end

  def encoded_content
    NKF.nkf('-w', content)
  end

  def cp(filename, binmode = false)
    File.open(filename, "w") do |f|
      content = binmode ? conent : encoded_content
      f.write content
    end
  end

  def file? ; true  ; end
  def dir?  ; false ; end
end
