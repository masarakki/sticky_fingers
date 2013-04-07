#include "sticky_fingers.h"

VALUE StickyFinger;

static VALUE sticky_fingers_alloc(VALUE klass);

void Init_sticky_fingers() {
    StickFinger = rb_define_class("StickyFingers", rb_cObject);
}

static VALUE sticky_fingers_alloc(VALUE klass) {
    struct sticky_fingers *sticky_fingers = ALLOC(struct sticky_fingers);
    return Data_Wrap_Struct(klass, sticky_fingers_mark, sticky_fingers_free, sticky_fingers);
}

static void sticky_fingers_mark(struct sticky_fingers *p) {
}

static void sticky_fingers_free(struct sticky_fingers *p) {
    xfree(p);
}
