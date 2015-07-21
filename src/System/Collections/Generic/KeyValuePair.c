/* KeyValuePair.c generated by valac 0.29.2.5-8632-dirty, the Vala compiler
 * generated from KeyValuePair.vala, do not modify */

/* ==++==*/
/* */
/*   Copyright (c) Microsoft Corporation.  All rights reserved.*/
/* */
/* ==--==*/
/*============================================================
**
** Interface:  KeyValuePair
** 
** <OWNER>[....]</OWNER>
**
**
** Purpose: Generic key-value pair for dictionary enumerators.
**
** 
===========================================================*/

#include <glib.h>
#include <glib-object.h>
#include <stdlib.h>
#include <string.h>
#include <gobject/gvaluecollector.h>


#define SYSTEM_COLLECTIONS_GENERIC_TYPE_KEY_VALUE_PAIR (system_collections_generic_key_value_pair_get_type ())
#define SYSTEM_COLLECTIONS_GENERIC_KEY_VALUE_PAIR(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_KEY_VALUE_PAIR, SystemCollectionsGenericKeyValuePair))
#define SYSTEM_COLLECTIONS_GENERIC_KEY_VALUE_PAIR_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SYSTEM_COLLECTIONS_GENERIC_TYPE_KEY_VALUE_PAIR, SystemCollectionsGenericKeyValuePairClass))
#define SYSTEM_COLLECTIONS_GENERIC_IS_KEY_VALUE_PAIR(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_KEY_VALUE_PAIR))
#define SYSTEM_COLLECTIONS_GENERIC_IS_KEY_VALUE_PAIR_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SYSTEM_COLLECTIONS_GENERIC_TYPE_KEY_VALUE_PAIR))
#define SYSTEM_COLLECTIONS_GENERIC_KEY_VALUE_PAIR_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_KEY_VALUE_PAIR, SystemCollectionsGenericKeyValuePairClass))

typedef struct _SystemCollectionsGenericKeyValuePair SystemCollectionsGenericKeyValuePair;
typedef struct _SystemCollectionsGenericKeyValuePairClass SystemCollectionsGenericKeyValuePairClass;
typedef struct _SystemCollectionsGenericKeyValuePairPrivate SystemCollectionsGenericKeyValuePairPrivate;
#define _tkey_destroy_func0(var) (((var == NULL) || (tkey_destroy_func == NULL)) ? NULL : (var = (tkey_destroy_func (var), NULL)))
#define _tvalue_destroy_func0(var) (((var == NULL) || (tvalue_destroy_func == NULL)) ? NULL : (var = (tvalue_destroy_func (var), NULL)))
typedef struct _SystemCollectionsGenericParamSpecKeyValuePair SystemCollectionsGenericParamSpecKeyValuePair;

struct _SystemCollectionsGenericKeyValuePair {
	GTypeInstance parent_instance;
	volatile int ref_count;
	SystemCollectionsGenericKeyValuePairPrivate * priv;
};

struct _SystemCollectionsGenericKeyValuePairClass {
	GTypeClass parent_class;
	void (*finalize) (SystemCollectionsGenericKeyValuePair *self);
};

struct _SystemCollectionsGenericKeyValuePairPrivate {
	GType tkey_type;
	GBoxedCopyFunc tkey_dup_func;
	GDestroyNotify tkey_destroy_func;
	GType tvalue_type;
	GBoxedCopyFunc tvalue_dup_func;
	GDestroyNotify tvalue_destroy_func;
	gpointer key;
	gpointer value;
};

struct _SystemCollectionsGenericParamSpecKeyValuePair {
	GParamSpec parent_instance;
};


static gpointer system_collections_generic_key_value_pair_parent_class = NULL;

gpointer system_collections_generic_key_value_pair_ref (gpointer instance);
void system_collections_generic_key_value_pair_unref (gpointer instance);
GParamSpec* system_collections_generic_param_spec_key_value_pair (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void system_collections_generic_value_set_key_value_pair (GValue* value, gpointer v_object);
void system_collections_generic_value_take_key_value_pair (GValue* value, gpointer v_object);
gpointer system_collections_generic_value_get_key_value_pair (const GValue* value);
GType system_collections_generic_key_value_pair_get_type (void) G_GNUC_CONST;
#define SYSTEM_COLLECTIONS_GENERIC_KEY_VALUE_PAIR_GET_PRIVATE(o) (G_TYPE_INSTANCE_GET_PRIVATE ((o), SYSTEM_COLLECTIONS_GENERIC_TYPE_KEY_VALUE_PAIR, SystemCollectionsGenericKeyValuePairPrivate))
enum  {
	SYSTEM_COLLECTIONS_GENERIC_KEY_VALUE_PAIR_DUMMY_PROPERTY
};
SystemCollectionsGenericKeyValuePair* system_collections_generic_key_value_pair_new (GType tkey_type, GBoxedCopyFunc tkey_dup_func, GDestroyNotify tkey_destroy_func, GType tvalue_type, GBoxedCopyFunc tvalue_dup_func, GDestroyNotify tvalue_destroy_func, gconstpointer key, gconstpointer value);
SystemCollectionsGenericKeyValuePair* system_collections_generic_key_value_pair_construct (GType object_type, GType tkey_type, GBoxedCopyFunc tkey_dup_func, GDestroyNotify tkey_destroy_func, GType tvalue_type, GBoxedCopyFunc tvalue_dup_func, GDestroyNotify tvalue_destroy_func, gconstpointer key, gconstpointer value);
gchar* system_collections_generic_key_value_pair_ToString (SystemCollectionsGenericKeyValuePair* self, GString* s);
gconstpointer system_collections_generic_key_value_pair_get_Key (SystemCollectionsGenericKeyValuePair* self);
gconstpointer system_collections_generic_key_value_pair_get_Value (SystemCollectionsGenericKeyValuePair* self);
static void system_collections_generic_key_value_pair_finalize (SystemCollectionsGenericKeyValuePair* obj);


SystemCollectionsGenericKeyValuePair* system_collections_generic_key_value_pair_construct (GType object_type, GType tkey_type, GBoxedCopyFunc tkey_dup_func, GDestroyNotify tkey_destroy_func, GType tvalue_type, GBoxedCopyFunc tvalue_dup_func, GDestroyNotify tvalue_destroy_func, gconstpointer key, gconstpointer value) {
	SystemCollectionsGenericKeyValuePair* self = NULL;
	gconstpointer _tmp0_ = NULL;
	gpointer _tmp1_ = NULL;
	gconstpointer _tmp2_ = NULL;
	gpointer _tmp3_ = NULL;
#line 30 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	self = (SystemCollectionsGenericKeyValuePair*) g_type_create_instance (object_type);
#line 30 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	self->priv->tkey_type = tkey_type;
#line 30 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	self->priv->tkey_dup_func = tkey_dup_func;
#line 30 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	self->priv->tkey_destroy_func = tkey_destroy_func;
#line 30 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	self->priv->tvalue_type = tvalue_type;
#line 30 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	self->priv->tvalue_dup_func = tvalue_dup_func;
#line 30 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	self->priv->tvalue_destroy_func = tvalue_destroy_func;
#line 31 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	_tmp0_ = key;
#line 31 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	_tmp1_ = ((_tmp0_ != NULL) && (tkey_dup_func != NULL)) ? tkey_dup_func ((gpointer) _tmp0_) : ((gpointer) _tmp0_);
#line 31 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	_tkey_destroy_func0 (self->priv->key);
#line 31 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	self->priv->key = _tmp1_;
#line 32 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	_tmp2_ = value;
#line 32 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	_tmp3_ = ((_tmp2_ != NULL) && (tvalue_dup_func != NULL)) ? tvalue_dup_func ((gpointer) _tmp2_) : ((gpointer) _tmp2_);
#line 32 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	_tvalue_destroy_func0 (self->priv->value);
#line 32 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	self->priv->value = _tmp3_;
#line 30 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	return self;
#line 129 "KeyValuePair.c"
}


SystemCollectionsGenericKeyValuePair* system_collections_generic_key_value_pair_new (GType tkey_type, GBoxedCopyFunc tkey_dup_func, GDestroyNotify tkey_destroy_func, GType tvalue_type, GBoxedCopyFunc tvalue_dup_func, GDestroyNotify tvalue_destroy_func, gconstpointer key, gconstpointer value) {
#line 30 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	return system_collections_generic_key_value_pair_construct (SYSTEM_COLLECTIONS_GENERIC_TYPE_KEY_VALUE_PAIR, tkey_type, tkey_dup_func, tkey_destroy_func, tvalue_type, tvalue_dup_func, tvalue_destroy_func, key, value);
#line 136 "KeyValuePair.c"
}


gchar* system_collections_generic_key_value_pair_ToString (SystemCollectionsGenericKeyValuePair* self, GString* s) {
	gchar* result = NULL;
	gchar* _tmp0_ = NULL;
#line 43 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	g_return_val_if_fail (self != NULL, NULL);
#line 43 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	g_return_val_if_fail (s != NULL, NULL);
#line 55 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	_tmp0_ = g_strdup ("");
#line 55 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	result = _tmp0_;
#line 55 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	return result;
#line 153 "KeyValuePair.c"
}


gconstpointer system_collections_generic_key_value_pair_get_Key (SystemCollectionsGenericKeyValuePair* self) {
	gconstpointer result;
	gconstpointer _tmp0_ = NULL;
#line 36 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	g_return_val_if_fail (self != NULL, NULL);
#line 36 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	_tmp0_ = self->priv->key;
#line 36 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	result = _tmp0_;
#line 36 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	return result;
#line 168 "KeyValuePair.c"
}


gconstpointer system_collections_generic_key_value_pair_get_Value (SystemCollectionsGenericKeyValuePair* self) {
	gconstpointer result;
	gconstpointer _tmp0_ = NULL;
#line 40 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	g_return_val_if_fail (self != NULL, NULL);
#line 40 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	_tmp0_ = self->priv->value;
#line 40 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	result = _tmp0_;
#line 40 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	return result;
#line 183 "KeyValuePair.c"
}


static void system_collections_generic_value_key_value_pair_init (GValue* value) {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	value->data[0].v_pointer = NULL;
#line 190 "KeyValuePair.c"
}


static void system_collections_generic_value_key_value_pair_free_value (GValue* value) {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	if (value->data[0].v_pointer) {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		system_collections_generic_key_value_pair_unref (value->data[0].v_pointer);
#line 199 "KeyValuePair.c"
	}
}


static void system_collections_generic_value_key_value_pair_copy_value (const GValue* src_value, GValue* dest_value) {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	if (src_value->data[0].v_pointer) {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		dest_value->data[0].v_pointer = system_collections_generic_key_value_pair_ref (src_value->data[0].v_pointer);
#line 209 "KeyValuePair.c"
	} else {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		dest_value->data[0].v_pointer = NULL;
#line 213 "KeyValuePair.c"
	}
}


static gpointer system_collections_generic_value_key_value_pair_peek_pointer (const GValue* value) {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	return value->data[0].v_pointer;
#line 221 "KeyValuePair.c"
}


static gchar* system_collections_generic_value_key_value_pair_collect_value (GValue* value, guint n_collect_values, GTypeCValue* collect_values, guint collect_flags) {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	if (collect_values[0].v_pointer) {
#line 228 "KeyValuePair.c"
		SystemCollectionsGenericKeyValuePair* object;
		object = collect_values[0].v_pointer;
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		if (object->parent_instance.g_class == NULL) {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
			return g_strconcat ("invalid unclassed object pointer for value type `", G_VALUE_TYPE_NAME (value), "'", NULL);
#line 235 "KeyValuePair.c"
		} else if (!g_value_type_compatible (G_TYPE_FROM_INSTANCE (object), G_VALUE_TYPE (value))) {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
			return g_strconcat ("invalid object type `", g_type_name (G_TYPE_FROM_INSTANCE (object)), "' for value type `", G_VALUE_TYPE_NAME (value), "'", NULL);
#line 239 "KeyValuePair.c"
		}
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		value->data[0].v_pointer = system_collections_generic_key_value_pair_ref (object);
#line 243 "KeyValuePair.c"
	} else {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		value->data[0].v_pointer = NULL;
#line 247 "KeyValuePair.c"
	}
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	return NULL;
#line 251 "KeyValuePair.c"
}


static gchar* system_collections_generic_value_key_value_pair_lcopy_value (const GValue* value, guint n_collect_values, GTypeCValue* collect_values, guint collect_flags) {
	SystemCollectionsGenericKeyValuePair** object_p;
	object_p = collect_values[0].v_pointer;
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	if (!object_p) {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		return g_strdup_printf ("value location for `%s' passed as NULL", G_VALUE_TYPE_NAME (value));
#line 262 "KeyValuePair.c"
	}
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	if (!value->data[0].v_pointer) {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		*object_p = NULL;
#line 268 "KeyValuePair.c"
	} else if (collect_flags & G_VALUE_NOCOPY_CONTENTS) {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		*object_p = value->data[0].v_pointer;
#line 272 "KeyValuePair.c"
	} else {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		*object_p = system_collections_generic_key_value_pair_ref (value->data[0].v_pointer);
#line 276 "KeyValuePair.c"
	}
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	return NULL;
#line 280 "KeyValuePair.c"
}


GParamSpec* system_collections_generic_param_spec_key_value_pair (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags) {
	SystemCollectionsGenericParamSpecKeyValuePair* spec;
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	g_return_val_if_fail (g_type_is_a (object_type, SYSTEM_COLLECTIONS_GENERIC_TYPE_KEY_VALUE_PAIR), NULL);
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	spec = g_param_spec_internal (G_TYPE_PARAM_OBJECT, name, nick, blurb, flags);
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	G_PARAM_SPEC (spec)->value_type = object_type;
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	return G_PARAM_SPEC (spec);
#line 294 "KeyValuePair.c"
}


gpointer system_collections_generic_value_get_key_value_pair (const GValue* value) {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	g_return_val_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, SYSTEM_COLLECTIONS_GENERIC_TYPE_KEY_VALUE_PAIR), NULL);
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	return value->data[0].v_pointer;
#line 303 "KeyValuePair.c"
}


void system_collections_generic_value_set_key_value_pair (GValue* value, gpointer v_object) {
	SystemCollectionsGenericKeyValuePair* old;
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	g_return_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, SYSTEM_COLLECTIONS_GENERIC_TYPE_KEY_VALUE_PAIR));
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	old = value->data[0].v_pointer;
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	if (v_object) {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		g_return_if_fail (G_TYPE_CHECK_INSTANCE_TYPE (v_object, SYSTEM_COLLECTIONS_GENERIC_TYPE_KEY_VALUE_PAIR));
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		g_return_if_fail (g_value_type_compatible (G_TYPE_FROM_INSTANCE (v_object), G_VALUE_TYPE (value)));
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		value->data[0].v_pointer = v_object;
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		system_collections_generic_key_value_pair_ref (value->data[0].v_pointer);
#line 323 "KeyValuePair.c"
	} else {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		value->data[0].v_pointer = NULL;
#line 327 "KeyValuePair.c"
	}
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	if (old) {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		system_collections_generic_key_value_pair_unref (old);
#line 333 "KeyValuePair.c"
	}
}


void system_collections_generic_value_take_key_value_pair (GValue* value, gpointer v_object) {
	SystemCollectionsGenericKeyValuePair* old;
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	g_return_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, SYSTEM_COLLECTIONS_GENERIC_TYPE_KEY_VALUE_PAIR));
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	old = value->data[0].v_pointer;
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	if (v_object) {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		g_return_if_fail (G_TYPE_CHECK_INSTANCE_TYPE (v_object, SYSTEM_COLLECTIONS_GENERIC_TYPE_KEY_VALUE_PAIR));
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		g_return_if_fail (g_value_type_compatible (G_TYPE_FROM_INSTANCE (v_object), G_VALUE_TYPE (value)));
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		value->data[0].v_pointer = v_object;
#line 352 "KeyValuePair.c"
	} else {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		value->data[0].v_pointer = NULL;
#line 356 "KeyValuePair.c"
	}
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	if (old) {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		system_collections_generic_key_value_pair_unref (old);
#line 362 "KeyValuePair.c"
	}
}


static void system_collections_generic_key_value_pair_class_init (SystemCollectionsGenericKeyValuePairClass * klass) {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	system_collections_generic_key_value_pair_parent_class = g_type_class_peek_parent (klass);
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	((SystemCollectionsGenericKeyValuePairClass *) klass)->finalize = system_collections_generic_key_value_pair_finalize;
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	g_type_class_add_private (klass, sizeof (SystemCollectionsGenericKeyValuePairPrivate));
#line 374 "KeyValuePair.c"
}


static void system_collections_generic_key_value_pair_instance_init (SystemCollectionsGenericKeyValuePair * self) {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	self->priv = SYSTEM_COLLECTIONS_GENERIC_KEY_VALUE_PAIR_GET_PRIVATE (self);
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	self->ref_count = 1;
#line 383 "KeyValuePair.c"
}


static void system_collections_generic_key_value_pair_finalize (SystemCollectionsGenericKeyValuePair* obj) {
	SystemCollectionsGenericKeyValuePair * self;
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	self = G_TYPE_CHECK_INSTANCE_CAST (obj, SYSTEM_COLLECTIONS_GENERIC_TYPE_KEY_VALUE_PAIR, SystemCollectionsGenericKeyValuePair);
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	g_signal_handlers_destroy (self);
#line 27 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	((self->priv->key == NULL) || (self->priv->tkey_destroy_func == NULL)) ? NULL : (self->priv->key = (self->priv->tkey_destroy_func (self->priv->key), NULL));
#line 28 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	((self->priv->value == NULL) || (self->priv->tvalue_destroy_func == NULL)) ? NULL : (self->priv->value = (self->priv->tvalue_destroy_func (self->priv->value), NULL));
#line 397 "KeyValuePair.c"
}


GType system_collections_generic_key_value_pair_get_type (void) {
	static volatile gsize system_collections_generic_key_value_pair_type_id__volatile = 0;
	if (g_once_init_enter (&system_collections_generic_key_value_pair_type_id__volatile)) {
		static const GTypeValueTable g_define_type_value_table = { system_collections_generic_value_key_value_pair_init, system_collections_generic_value_key_value_pair_free_value, system_collections_generic_value_key_value_pair_copy_value, system_collections_generic_value_key_value_pair_peek_pointer, "p", system_collections_generic_value_key_value_pair_collect_value, "p", system_collections_generic_value_key_value_pair_lcopy_value };
		static const GTypeInfo g_define_type_info = { sizeof (SystemCollectionsGenericKeyValuePairClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) system_collections_generic_key_value_pair_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (SystemCollectionsGenericKeyValuePair), 0, (GInstanceInitFunc) system_collections_generic_key_value_pair_instance_init, &g_define_type_value_table };
		static const GTypeFundamentalInfo g_define_type_fundamental_info = { (G_TYPE_FLAG_CLASSED | G_TYPE_FLAG_INSTANTIATABLE | G_TYPE_FLAG_DERIVABLE | G_TYPE_FLAG_DEEP_DERIVABLE) };
		GType system_collections_generic_key_value_pair_type_id;
		system_collections_generic_key_value_pair_type_id = g_type_register_fundamental (g_type_fundamental_next (), "SystemCollectionsGenericKeyValuePair", &g_define_type_info, &g_define_type_fundamental_info, 0);
		g_once_init_leave (&system_collections_generic_key_value_pair_type_id__volatile, system_collections_generic_key_value_pair_type_id);
	}
	return system_collections_generic_key_value_pair_type_id__volatile;
}


gpointer system_collections_generic_key_value_pair_ref (gpointer instance) {
	SystemCollectionsGenericKeyValuePair* self;
	self = instance;
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	g_atomic_int_inc (&self->ref_count);
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	return instance;
#line 422 "KeyValuePair.c"
}


void system_collections_generic_key_value_pair_unref (gpointer instance) {
	SystemCollectionsGenericKeyValuePair* self;
	self = instance;
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
	if (g_atomic_int_dec_and_test (&self->ref_count)) {
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		SYSTEM_COLLECTIONS_GENERIC_KEY_VALUE_PAIR_GET_CLASS (self)->finalize (self);
#line 26 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/KeyValuePair.vala"
		g_type_free_instance ((GTypeInstance *) self);
#line 435 "KeyValuePair.c"
	}
}



