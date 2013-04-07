require 'mkmf'

if have_header 'zip.h' and have_library 'zip'
  create_makefile 'sticky_fingers'
end
