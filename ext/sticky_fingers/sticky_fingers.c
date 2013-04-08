#include <zip.h>
#include "sticky_fingers.h"

VALUE StickyFingers;

static VALUE sticky_fingers_alloc(VALUE klass);
static void sticky_fingers_mark(struct sticky_fingers *p);
static void sticky_fingers_free(struct sticky_fingers *p);
static VALUE sticky_fingers_s_open_file(int args, VALUE *argv, VALUE self);

static void sticky_fingers_raise_error_on_open(int error_no);

void Init_sticky_fingers() {
    StickyFingers = rb_define_class("StickyFingers", rb_cObject);
    rb_define_alloc_func(StickyFingers, sticky_fingers_alloc);
    rb_define_singleton_method(StickyFingers, "open_file", sticky_fingers_s_open_file, -1);
}

static VALUE sticky_fingers_alloc(VALUE klass) {
    struct sticky_fingers *sticky_fingers = ALLOC(struct sticky_fingers);
    return Data_Wrap_Struct(klass, sticky_fingers_mark, sticky_fingers_free, sticky_fingers);
}

static void sticky_fingers_mark(struct sticky_fingers *p) {
}

static void sticky_fingers_free(struct sticky_fingers *p) {
    int close_result;
    if (p->zip) {
        close_result = zip_close(p->zip);
        if (close_result) {
            // TODO: handle error
        }
    }
    xfree(p);
}

static VALUE sticky_fingers_s_open_file(int argc, VALUE * argv, VALUE self) {
    VALUE filename;
    VALUE instance;
    int error_no;
    struct sticky_fingers *inner;
    rb_scan_args(argc, argv, "1", &filename);
    Check_Type(filename, T_STRING);

    instance = rb_funcall(StickyFingers, rb_intern("new"), 0);
    Data_Get_Struct(instance, struct sticky_fingers, inner);
    inner->zip = zip_open(RSTRING_PTR(filename), 0, &error_no);

    if (error_no) {
        sticky_fingers_raise_error_on_open(error_no);
    }

    return instance;
}


static void sticky_fingers_raise_error_on_open(int error_no) {
    // TODO: raise errors
    switch (error_no) {
    case ZIP_ER_EXISTS:
        // The file specified by path exists and ZIP_EXCL is set.
        break;
    case ZIP_ER_INCONS:
        // Inconsistencies were found in the file specified by path and ZIP_CHECKCONS was specified.
        break;
    case ZIP_ER_INVAL:
        // The path argument is NULL.
        break;
    case ZIP_ER_MEMORY:
        // Required memory could not be allocated.
        break;
    case ZIP_ER_NOENT:
        // The file specified by path does not exist and ZIP_CREATE is not set.
        break;
    case ZIP_ER_NOZIP:
        // The file specified by path is not a zip archive.
        break;
    case ZIP_ER_OPEN:
        // The file specified by path could not be opened.
        break;
    case ZIP_ER_READ:
        // A read error occurred; see for details.
    case ZIP_ER_SEEK:
        break;
    }
}
