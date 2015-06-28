/* libdotnet.h generated by valac 0.29.1, the Vala compiler, do not modify */


#ifndef __LIBDOTNET_H__
#define __LIBDOTNET_H__

#include <glib.h>
#include <glib-object.h>
#include <stdlib.h>
#include <string.h>

G_BEGIN_DECLS


#define LIB_TYPE_FOO (lib_foo_get_type ())
#define LIB_FOO(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), LIB_TYPE_FOO, LibFoo))
#define LIB_FOO_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), LIB_TYPE_FOO, LibFooClass))
#define LIB_IS_FOO(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), LIB_TYPE_FOO))
#define LIB_IS_FOO_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), LIB_TYPE_FOO))
#define LIB_FOO_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), LIB_TYPE_FOO, LibFooClass))

typedef struct _LibFoo LibFoo;
typedef struct _LibFooClass LibFooClass;
typedef struct _LibFooPrivate LibFooPrivate;

#define SYSTEM_COLLECTIONS_GENERIC_TYPE_KEY_VALUE_PAIR (system_collections_generic_key_value_pair_get_type ())
typedef struct _SystemCollectionsGenericKeyValuePair SystemCollectionsGenericKeyValuePair;

struct _LibFoo {
	GObject parent_instance;
	LibFooPrivate * priv;
};

struct _LibFooClass {
	GObjectClass parent_class;
};

struct _SystemCollectionsGenericKeyValuePair {
	gpointer _Key;
	gpointer _Value;
};


GType lib_foo_get_type (void) G_GNUC_CONST;
gint lib_foo_add (LibFoo* self, gint a, gint b);
gint lib_foo_mux (LibFoo* self, gint a, gint b);
LibFoo* lib_foo_new (void);
LibFoo* lib_foo_construct (GType object_type);
GType system_collections_generic_key_value_pair_get_type (void) G_GNUC_CONST;
SystemCollectionsGenericKeyValuePair* system_collections_generic_key_value_pair_dup (const SystemCollectionsGenericKeyValuePair* self);
void system_collections_generic_key_value_pair_free (SystemCollectionsGenericKeyValuePair* self);
void system_collections_generic_key_value_pair_copy (const SystemCollectionsGenericKeyValuePair* self, SystemCollectionsGenericKeyValuePair* dest);
void system_collections_generic_key_value_pair_destroy (SystemCollectionsGenericKeyValuePair* self);
gchar* system_collections_generic_key_value_pair_ToString (SystemCollectionsGenericKeyValuePair *self);


G_END_DECLS

#endif
