#ifndef __STICKY_FINGERS_H__
#define __STICKY_FINGERS_H__

#define ST_BUFSIZE 512

#include <zip.h>

void Init_sticky_fingers();

struct sticky_fingers {
    struct zip *zip;
};

#endif
