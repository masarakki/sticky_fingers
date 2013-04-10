# sticky_fingers

sticky_fingers is a stand of Bruno Buccellati having special ability to read zip archive.

## Concept

zipruby is too hard to learn, I want to use more easy like this.

```ruby
StickyFingers.open('file.zip') do
  ls # => ['file1.txt', 'file2.txt', 'dir1/', 'dir2/']
  cd 'dir2' do
    ls # => ['a.txt', 'b.txt', 'dir3/']
    ls :files do |file| # => enumerate only normal files
      cp file, File.join(ENV['HOME'], 'dst', file)
    end
  end
  x = cat 'file1.txt' # => "hello, world!"
end
```

it's naturaly.

## Copyright

Copyright (c) 2013 masarakki. See LICENSE.txt for
further details.

