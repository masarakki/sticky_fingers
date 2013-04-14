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
                   guess = NKF.guess(content)
                   content = content.encode(Encoding::UTF_8, guess) unless guess == Encoding::ASCII_8BIT
                   content
                 end
  end

  def cp(filename, binmode = false)
    File.open(filename, "w") do |f|
      f.write content
    end
  end

  def file? ; true  ; end
  def dir?  ; false ; end
end
