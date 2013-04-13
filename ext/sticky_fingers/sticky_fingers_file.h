#ifndef __STICKY_FINGERS_FILE_H__
#define __STICKY_FINGERS_FILE_H__

#include <zip.h>

void Init_sticky_fingers_file();

struct sticky_fingers_file {
    struct zip_file *zip_file;
};

#endif
