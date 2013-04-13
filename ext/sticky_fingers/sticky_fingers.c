#include <zip.h>
#include <errno.h>
#include "ruby.h"
#include "sticky_fingers.h"
#include "sticky_fingers_error.h"
#include "sticky_fingers_file.h"

VALUE StickyFingers;
extern VALUE StickyFingers_Error;
extern VALUE StickyFingers_File;

static VALUE sticky_fingers_alloc(VALUE klass);
static void sticky_fingers_mark(struct sticky_fingers *p);
static void sticky_fingers_free(struct sticky_fingers *p);
static VALUE sticky_fingers_s_open_file(int args, VALUE *argv, VALUE self);
static VALUE sticky_fingers_list_files(VALUE self);
static void sticky_fingers_raise_error(int zip_errno, int global_errno);

void Init_sticky_fingers() {
    StickyFingers = rb_define_class("StickyFingers", rb_cObject);
    rb_define_alloc_func(StickyFingers, sticky_fingers_alloc);
    rb_define_singleton_method(StickyFingers, "open_file", sticky_fingers_s_open_file, -1);
    rb_define_method(StickyFingers, "list_files", sticky_fingers_list_files, 0);

    Init_sticky_fingers_error();
    Init_sticky_fingers_file();
}

static VALUE sticky_fingers_alloc(VALUE klass) {
    struct sticky_fingers *sticky_fingers = ALLOC(struct sticky_fingers);
    return Data_Wrap_Struct(klass, sticky_fingers_mark, sticky_fingers_free, sticky_fingers);
}

static void sticky_fingers_mark(struct sticky_fingers *p) {
}

static void sticky_fingers_free(struct sticky_fingers *p) {
    int close_result = 0;
    if (p->zip) {
        errno = 0;
        close_result = zip_close(p->zip);
        if (close_result) {
            sticky_fingers_raise_error(close_result, errno);
        }
    }
    xfree(p);
}

static VALUE sticky_fingers_s_open_file(int argc, VALUE * argv, VALUE self) {
    VALUE filename;
    VALUE instance;
    int zip_errno = 0;
    struct sticky_fingers *inner;
    rb_scan_args(argc, argv, "1", &filename);
    Check_Type(filename, T_STRING);

    instance = rb_funcall(StickyFingers, rb_intern("new"), 0);
    Data_Get_Struct(instance, struct sticky_fingers, inner);
    errno = 0;
    inner->zip = zip_open(RSTRING_PTR(filename), 0, &zip_errno);
    if (zip_errno) {
        sticky_fingers_raise_error(zip_errno, errno);
    }

    return instance;
}

static VALUE sticky_fingers_list_files(VALUE self) {
    struct sticky_fingers *inner;
    VALUE files;
    int num_files;
    int file_index;
    char *filename;
    Data_Get_Struct(self, struct sticky_fingers, inner);

    files = rb_ary_new();
    num_files = zip_get_num_files(inner->zip);

    for (file_index = 0; file_index < num_files; file_index++) {
        filename = zip_get_name(inner->zip, file_index, 0);
        rb_ary_push(files, rb_str_new2(filename));
    }

    return files;
}

static void sticky_fingers_raise_error(int zip_errno, int global_errno) {
    char buffer[ST_BUFSIZE];
    zip_error_to_str(buffer, ST_BUFSIZE, zip_errno, global_errno);
    rb_raise(StickyFingers_Error, "Error: %s", buffer);
}
