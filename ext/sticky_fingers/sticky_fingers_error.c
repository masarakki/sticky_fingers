#include "sticky_fingers.h"
#include "sticky_fingers_error.h"
#include "ruby.h"

extern VALUE StickyFingers;
VALUE StickyFingers_Error;

void Init_sticky_fingers_error() {
    StickyFingers_Error = rb_define_class_under(StickyFingers, "Error", rb_eStandardError);
}
