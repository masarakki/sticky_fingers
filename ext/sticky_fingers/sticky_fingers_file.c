#include <zip.h>
#include "ruby.h"
#include "sticky_fingers.h"
#include "sticky_fingers_file.h"

extern VALUE StickyFingers;
VALUE StickyFingers_File;
extern VALUE StickyFingers_Error;

static VALUE sticky_fingers_file_alloc(VALUE klass);
static void sticky_fingers_file_mark(struct sticky_fingers_file *p);
static void sticky_fingers_file_free(struct sticky_fingers_file *p);
static VALUE sticky_fingers_file_open(VALUE self);
static VALUE sticky_fingers_file_close(VALUE self);

void Init_sticky_fingers_file() {
    StickyFingers_File = rb_define_class_under(StickyFingers, "File", rb_cObject);
    rb_define_alloc_func(StickyFingers_File, sticky_fingers_file_alloc);
    rb_define_method(StickyFingers_File, "open", sticky_fingers_file_open, 0);
    rb_define_method(StickyFingers_File, "close", sticky_fingers_file_close, 0);
}

static VALUE sticky_fingers_file_alloc(VALUE klass) {
    struct sticky_fingers_file *p_file = ALLOC(struct sticky_fingers_file);
    p_file->zip_file = NULL;
    return Data_Wrap_Struct(klass, sticky_fingers_file_mark, sticky_fingers_file_free, p_file);
}

static void sticky_fingers_file_mark(struct sticky_fingers_file *p) {
}

static void sticky_fingers_file_free(struct sticky_fingers_file *p) {
    int close_errno = 0;
    if (p->zip_file) {
        close_errno = zip_fclose(p->zip_file);
        if (close_errno) {
            sticky_fingers_file_raise_error(close_errno, 0);
        }
    }
    xfree(p);
}

static VALUE sticky_fingers_file_open(VALUE self) {
    VALUE archive, filename;
    struct sticky_fingers *p_archive;
    struct sticky_fingers_file *p_file;
    struct zip_file *zip_file;
    int strlen, zlib_errno, system_errno;
    char *cfilename;
    char error_message[512];

    archive = rb_iv_get(self, "@archive");
    filename = rb_iv_get(self, "@filename");
    cfilename = StringValuePtr(filename);

    Data_Get_Struct(archive, struct sticky_fingers, p_archive);
    zip_file = zip_fopen(p_archive->zip, cfilename, ZIP_FL_COMPRESSED);

    if (zip_file == NULL) {
        zip_error_get(p_archive->zip, &zlib_errno, &system_errno);
        sticky_fingers_file_raise_error(zlib_errno, system_errno);
    } else {
        Data_Get_Struct(self, struct sticky_fingers_file, p_file);
        p_file->zip_file = zip_file;
        return Qnil;
    }
}

static VALUE sticky_fingers_file_close(VALUE self) {
    struct sticky_fingers_file *p_file;
    int error = 0;
    Data_Get_Struct(self, struct sticky_fingers_file, p_file);

    if (p_file->zip_file) {
        error = zip_fclose(p_file->zip_file);
        if (error) {
            sticky_fingers_file_raise_error(error, 0);
        }
        p_file->zip_file = NULL;
    }
    return Qtrue;
}

void sticky_fingers_file_raise_error(int zlib_errno, int system_errno) {
    char error_message[512];
    zip_error_to_str(&error_message, 512, zlib_errno, system_errno);
    rb_raise(StickyFingers_Error, "Error: %s", error_message);
}
