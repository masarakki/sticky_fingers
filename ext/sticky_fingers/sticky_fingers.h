#ifndef __STICKY_FINGERS_GEM__
#define __STICKY_FINGERS_GEM__

#include "ruby.h"
void Init_sticky_fingers();

struct sticky_fingers {
    struct zip *zip;
};
#endif
