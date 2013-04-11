require 'mkmf'

if have_header 'zip.h' and have_library 'zip' and have_header 'errno.h'
  create_makefile 'sticky_fingers'
end
