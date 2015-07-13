/* CaseInsensitiveHashCodeProvider.c generated by valac 0.26.2, the Vala compiler
 * generated from CaseInsensitiveHashCodeProvider.vala, do not modify */

/* ==++==*/
/* */
/*   Copyright (c) Microsoft Corporation.  All rights reserved.*/
/* */
/* ==--==*/
/*============================================================
**
** Class: CaseInsensitiveHashCodeProvider
** 
** <OWNER>[....]</OWNER>
**
**
** Purpose: Designed to support hashtables which require 
** case-insensitive behavior while still maintaining case,
** this provides an efficient mechanism for getting the 
** hashcode of the string ignoring case.
**
**
============================================================*/

#include <glib.h>
#include <glib-object.h>
#include <gobject/gvaluecollector.h>


#define SYSTEM_COLLECTIONS_TYPE_IHASH_CODE_PROVIDER (system_collections_ihash_code_provider_get_type ())
#define SYSTEM_COLLECTIONS_IHASH_CODE_PROVIDER(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_TYPE_IHASH_CODE_PROVIDER, SystemCollectionsIHashCodeProvider))
#define SYSTEM_COLLECTIONS_IS_IHASH_CODE_PROVIDER(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_TYPE_IHASH_CODE_PROVIDER))
#define SYSTEM_COLLECTIONS_IHASH_CODE_PROVIDER_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_TYPE_IHASH_CODE_PROVIDER, SystemCollectionsIHashCodeProviderIface))

typedef struct _SystemCollectionsIHashCodeProvider SystemCollectionsIHashCodeProvider;
typedef struct _SystemCollectionsIHashCodeProviderIface SystemCollectionsIHashCodeProviderIface;

#define SYSTEM_COLLECTIONS_TYPE_CASE_INSENSITIVE_HASH_CODE_PROVIDER (system_collections_case_insensitive_hash_code_provider_get_type ())
#define SYSTEM_COLLECTIONS_CASE_INSENSITIVE_HASH_CODE_PROVIDER(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_TYPE_CASE_INSENSITIVE_HASH_CODE_PROVIDER, SystemCollectionsCaseInsensitiveHashCodeProvider))
#define SYSTEM_COLLECTIONS_CASE_INSENSITIVE_HASH_CODE_PROVIDER_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SYSTEM_COLLECTIONS_TYPE_CASE_INSENSITIVE_HASH_CODE_PROVIDER, SystemCollectionsCaseInsensitiveHashCodeProviderClass))
#define SYSTEM_COLLECTIONS_IS_CASE_INSENSITIVE_HASH_CODE_PROVIDER(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_TYPE_CASE_INSENSITIVE_HASH_CODE_PROVIDER))
#define SYSTEM_COLLECTIONS_IS_CASE_INSENSITIVE_HASH_CODE_PROVIDER_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SYSTEM_COLLECTIONS_TYPE_CASE_INSENSITIVE_HASH_CODE_PROVIDER))
#define SYSTEM_COLLECTIONS_CASE_INSENSITIVE_HASH_CODE_PROVIDER_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SYSTEM_COLLECTIONS_TYPE_CASE_INSENSITIVE_HASH_CODE_PROVIDER, SystemCollectionsCaseInsensitiveHashCodeProviderClass))

typedef struct _SystemCollectionsCaseInsensitiveHashCodeProvider SystemCollectionsCaseInsensitiveHashCodeProvider;
typedef struct _SystemCollectionsCaseInsensitiveHashCodeProviderClass SystemCollectionsCaseInsensitiveHashCodeProviderClass;
typedef struct _SystemCollectionsCaseInsensitiveHashCodeProviderPrivate SystemCollectionsCaseInsensitiveHashCodeProviderPrivate;

#define SYSTEM_GLOBALIZATION_TYPE_CULTURE_INFO (system_globalization_culture_info_get_type ())
#define _system_collections_case_insensitive_hash_code_provider_unref0(var) ((var == NULL) ? NULL : (var = (system_collections_case_insensitive_hash_code_provider_unref (var), NULL)))
typedef struct _SystemCollectionsParamSpecCaseInsensitiveHashCodeProvider SystemCollectionsParamSpecCaseInsensitiveHashCodeProvider;

struct _SystemCollectionsIHashCodeProviderIface {
	GTypeInterface parent_iface;
	gint (*GetHashCode) (SystemCollectionsIHashCodeProvider* self, GObject* obj);
};

struct _SystemCollectionsCaseInsensitiveHashCodeProvider {
	GTypeInstance parent_instance;
	volatile int ref_count;
	SystemCollectionsCaseInsensitiveHashCodeProviderPrivate * priv;
};

struct _SystemCollectionsCaseInsensitiveHashCodeProviderClass {
	GTypeClass parent_class;
	void (*finalize) (SystemCollectionsCaseInsensitiveHashCodeProvider *self);
};

typedef enum  {
	SYSTEM_GLOBALIZATION_CULTURE_INFO_InvariantCulture,
	SYSTEM_GLOBALIZATION_CULTURE_INFO_CurrentCulture
} SystemGlobalizationCultureInfo;

struct _SystemCollectionsCaseInsensitiveHashCodeProviderPrivate {
	SystemGlobalizationCultureInfo culture;
};

struct _SystemCollectionsParamSpecCaseInsensitiveHashCodeProvider {
	GParamSpec parent_instance;
};


static gpointer system_collections_case_insensitive_hash_code_provider_parent_class = NULL;
static SystemCollectionsCaseInsensitiveHashCodeProvider* system_collections_case_insensitive_hash_code_provider_m_InvariantCaseInsensitiveHashCodeProvider;
static SystemCollectionsCaseInsensitiveHashCodeProvider* system_collections_case_insensitive_hash_code_provider_m_InvariantCaseInsensitiveHashCodeProvider = NULL;
static SystemCollectionsIHashCodeProviderIface* system_collections_case_insensitive_hash_code_provider_system_collections_ihash_code_provider_parent_iface = NULL;

GType system_collections_ihash_code_provider_get_type (void) G_GNUC_CONST;
gpointer system_collections_case_insensitive_hash_code_provider_ref (gpointer instance);
void system_collections_case_insensitive_hash_code_provider_unref (gpointer instance);
GParamSpec* system_collections_param_spec_case_insensitive_hash_code_provider (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void system_collections_value_set_case_insensitive_hash_code_provider (GValue* value, gpointer v_object);
void system_collections_value_take_case_insensitive_hash_code_provider (GValue* value, gpointer v_object);
gpointer system_collections_value_get_case_insensitive_hash_code_provider (const GValue* value);
GType system_collections_case_insensitive_hash_code_provider_get_type (void) G_GNUC_CONST;
GType system_globalization_culture_info_get_type (void) G_GNUC_CONST;
#define SYSTEM_COLLECTIONS_CASE_INSENSITIVE_HASH_CODE_PROVIDER_GET_PRIVATE(o) (G_TYPE_INSTANCE_GET_PRIVATE ((o), SYSTEM_COLLECTIONS_TYPE_CASE_INSENSITIVE_HASH_CODE_PROVIDER, SystemCollectionsCaseInsensitiveHashCodeProviderPrivate))
enum  {
	SYSTEM_COLLECTIONS_CASE_INSENSITIVE_HASH_CODE_PROVIDER_DUMMY_PROPERTY
};
SystemCollectionsCaseInsensitiveHashCodeProvider* system_collections_case_insensitive_hash_code_provider_new (SystemGlobalizationCultureInfo* culture);
SystemCollectionsCaseInsensitiveHashCodeProvider* system_collections_case_insensitive_hash_code_provider_construct (GType object_type, SystemGlobalizationCultureInfo* culture);
static gint system_collections_case_insensitive_hash_code_provider_real_GetHashCode (SystemCollectionsIHashCodeProvider* base, GObject* obj);
SystemCollectionsCaseInsensitiveHashCodeProvider* system_collections_case_insensitive_hash_code_provider_get_Default (void);
SystemCollectionsCaseInsensitiveHashCodeProvider* system_collections_case_insensitive_hash_code_provider_get_DefaultInvariant (void);
static void system_collections_case_insensitive_hash_code_provider_finalize (SystemCollectionsCaseInsensitiveHashCodeProvider* obj);


SystemCollectionsCaseInsensitiveHashCodeProvider* system_collections_case_insensitive_hash_code_provider_construct (GType object_type, SystemGlobalizationCultureInfo* culture) {
	SystemCollectionsCaseInsensitiveHashCodeProvider* self = NULL;
	SystemGlobalizationCultureInfo* _tmp0_ = NULL;
	self = (SystemCollectionsCaseInsensitiveHashCodeProvider*) g_type_create_instance (object_type);
	_tmp0_ = culture;
	self->priv->culture = *_tmp0_;
	return self;
}


SystemCollectionsCaseInsensitiveHashCodeProvider* system_collections_case_insensitive_hash_code_provider_new (SystemGlobalizationCultureInfo* culture) {
	return system_collections_case_insensitive_hash_code_provider_construct (SYSTEM_COLLECTIONS_TYPE_CASE_INSENSITIVE_HASH_CODE_PROVIDER, culture);
}


static gint system_collections_case_insensitive_hash_code_provider_real_GetHashCode (SystemCollectionsIHashCodeProvider* base, GObject* obj) {
	SystemCollectionsCaseInsensitiveHashCodeProvider * self;
	gint result = 0;
	self = (SystemCollectionsCaseInsensitiveHashCodeProvider*) base;
	g_return_val_if_fail (obj != NULL, 0);
	result = -1;
	return result;
}


SystemCollectionsCaseInsensitiveHashCodeProvider* system_collections_case_insensitive_hash_code_provider_get_Default (void) {
	SystemCollectionsCaseInsensitiveHashCodeProvider* result;
	SystemGlobalizationCultureInfo _tmp0_ = 0;
	SystemCollectionsCaseInsensitiveHashCodeProvider* _tmp1_ = NULL;
	_tmp0_ = SYSTEM_GLOBALIZATION_CULTURE_INFO_CurrentCulture;
	_tmp1_ = system_collections_case_insensitive_hash_code_provider_new (&_tmp0_);
	result = _tmp1_;
	return result;
}


SystemCollectionsCaseInsensitiveHashCodeProvider* system_collections_case_insensitive_hash_code_provider_get_DefaultInvariant (void) {
	SystemCollectionsCaseInsensitiveHashCodeProvider* result;
	SystemCollectionsCaseInsensitiveHashCodeProvider* _tmp0_ = NULL;
	SystemCollectionsCaseInsensitiveHashCodeProvider* _tmp3_ = NULL;
	_tmp0_ = system_collections_case_insensitive_hash_code_provider_m_InvariantCaseInsensitiveHashCodeProvider;
	if (_tmp0_ == NULL) {
		SystemGlobalizationCultureInfo _tmp1_ = 0;
		SystemCollectionsCaseInsensitiveHashCodeProvider* _tmp2_ = NULL;
		_tmp1_ = SYSTEM_GLOBALIZATION_CULTURE_INFO_InvariantCulture;
		_tmp2_ = system_collections_case_insensitive_hash_code_provider_new (&_tmp1_);
		_system_collections_case_insensitive_hash_code_provider_unref0 (system_collections_case_insensitive_hash_code_provider_m_InvariantCaseInsensitiveHashCodeProvider);
		system_collections_case_insensitive_hash_code_provider_m_InvariantCaseInsensitiveHashCodeProvider = _tmp2_;
	}
	_tmp3_ = system_collections_case_insensitive_hash_code_provider_m_InvariantCaseInsensitiveHashCodeProvider;
	result = _tmp3_;
	return result;
}


static void system_collections_value_case_insensitive_hash_code_provider_init (GValue* value) {
	value->data[0].v_pointer = NULL;
}


static void system_collections_value_case_insensitive_hash_code_provider_free_value (GValue* value) {
	if (value->data[0].v_pointer) {
		system_collections_case_insensitive_hash_code_provider_unref (value->data[0].v_pointer);
	}
}


static void system_collections_value_case_insensitive_hash_code_provider_copy_value (const GValue* src_value, GValue* dest_value) {
	if (src_value->data[0].v_pointer) {
		dest_value->data[0].v_pointer = system_collections_case_insensitive_hash_code_provider_ref (src_value->data[0].v_pointer);
	} else {
		dest_value->data[0].v_pointer = NULL;
	}
}


static gpointer system_collections_value_case_insensitive_hash_code_provider_peek_pointer (const GValue* value) {
	return value->data[0].v_pointer;
}


static gchar* system_collections_value_case_insensitive_hash_code_provider_collect_value (GValue* value, guint n_collect_values, GTypeCValue* collect_values, guint collect_flags) {
	if (collect_values[0].v_pointer) {
		SystemCollectionsCaseInsensitiveHashCodeProvider* object;
		object = collect_values[0].v_pointer;
		if (object->parent_instance.g_class == NULL) {
			return g_strconcat ("invalid unclassed object pointer for value type `", G_VALUE_TYPE_NAME (value), "'", NULL);
		} else if (!g_value_type_compatible (G_TYPE_FROM_INSTANCE (object), G_VALUE_TYPE (value))) {
			return g_strconcat ("invalid object type `", g_type_name (G_TYPE_FROM_INSTANCE (object)), "' for value type `", G_VALUE_TYPE_NAME (value), "'", NULL);
		}
		value->data[0].v_pointer = system_collections_case_insensitive_hash_code_provider_ref (object);
	} else {
		value->data[0].v_pointer = NULL;
	}
	return NULL;
}


static gchar* system_collections_value_case_insensitive_hash_code_provider_lcopy_value (const GValue* value, guint n_collect_values, GTypeCValue* collect_values, guint collect_flags) {
	SystemCollectionsCaseInsensitiveHashCodeProvider** object_p;
	object_p = collect_values[0].v_pointer;
	if (!object_p) {
		return g_strdup_printf ("value location for `%s' passed as NULL", G_VALUE_TYPE_NAME (value));
	}
	if (!value->data[0].v_pointer) {
		*object_p = NULL;
	} else if (collect_flags & G_VALUE_NOCOPY_CONTENTS) {
		*object_p = value->data[0].v_pointer;
	} else {
		*object_p = system_collections_case_insensitive_hash_code_provider_ref (value->data[0].v_pointer);
	}
	return NULL;
}


GParamSpec* system_collections_param_spec_case_insensitive_hash_code_provider (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags) {
	SystemCollectionsParamSpecCaseInsensitiveHashCodeProvider* spec;
	g_return_val_if_fail (g_type_is_a (object_type, SYSTEM_COLLECTIONS_TYPE_CASE_INSENSITIVE_HASH_CODE_PROVIDER), NULL);
	spec = g_param_spec_internal (G_TYPE_PARAM_OBJECT, name, nick, blurb, flags);
	G_PARAM_SPEC (spec)->value_type = object_type;
	return G_PARAM_SPEC (spec);
}


gpointer system_collections_value_get_case_insensitive_hash_code_provider (const GValue* value) {
	g_return_val_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, SYSTEM_COLLECTIONS_TYPE_CASE_INSENSITIVE_HASH_CODE_PROVIDER), NULL);
	return value->data[0].v_pointer;
}


void system_collections_value_set_case_insensitive_hash_code_provider (GValue* value, gpointer v_object) {
	SystemCollectionsCaseInsensitiveHashCodeProvider* old;
	g_return_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, SYSTEM_COLLECTIONS_TYPE_CASE_INSENSITIVE_HASH_CODE_PROVIDER));
	old = value->data[0].v_pointer;
	if (v_object) {
		g_return_if_fail (G_TYPE_CHECK_INSTANCE_TYPE (v_object, SYSTEM_COLLECTIONS_TYPE_CASE_INSENSITIVE_HASH_CODE_PROVIDER));
		g_return_if_fail (g_value_type_compatible (G_TYPE_FROM_INSTANCE (v_object), G_VALUE_TYPE (value)));
		value->data[0].v_pointer = v_object;
		system_collections_case_insensitive_hash_code_provider_ref (value->data[0].v_pointer);
	} else {
		value->data[0].v_pointer = NULL;
	}
	if (old) {
		system_collections_case_insensitive_hash_code_provider_unref (old);
	}
}


void system_collections_value_take_case_insensitive_hash_code_provider (GValue* value, gpointer v_object) {
	SystemCollectionsCaseInsensitiveHashCodeProvider* old;
	g_return_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, SYSTEM_COLLECTIONS_TYPE_CASE_INSENSITIVE_HASH_CODE_PROVIDER));
	old = value->data[0].v_pointer;
	if (v_object) {
		g_return_if_fail (G_TYPE_CHECK_INSTANCE_TYPE (v_object, SYSTEM_COLLECTIONS_TYPE_CASE_INSENSITIVE_HASH_CODE_PROVIDER));
		g_return_if_fail (g_value_type_compatible (G_TYPE_FROM_INSTANCE (v_object), G_VALUE_TYPE (value)));
		value->data[0].v_pointer = v_object;
	} else {
		value->data[0].v_pointer = NULL;
	}
	if (old) {
		system_collections_case_insensitive_hash_code_provider_unref (old);
	}
}


static void system_collections_case_insensitive_hash_code_provider_class_init (SystemCollectionsCaseInsensitiveHashCodeProviderClass * klass) {
	system_collections_case_insensitive_hash_code_provider_parent_class = g_type_class_peek_parent (klass);
	((SystemCollectionsCaseInsensitiveHashCodeProviderClass *) klass)->finalize = system_collections_case_insensitive_hash_code_provider_finalize;
	g_type_class_add_private (klass, sizeof (SystemCollectionsCaseInsensitiveHashCodeProviderPrivate));
}


static void system_collections_case_insensitive_hash_code_provider_system_collections_ihash_code_provider_interface_init (SystemCollectionsIHashCodeProviderIface * iface) {
	system_collections_case_insensitive_hash_code_provider_system_collections_ihash_code_provider_parent_iface = g_type_interface_peek_parent (iface);
	iface->GetHashCode = (gint (*)(SystemCollectionsIHashCodeProvider*, GObject*)) system_collections_case_insensitive_hash_code_provider_real_GetHashCode;
}


static void system_collections_case_insensitive_hash_code_provider_instance_init (SystemCollectionsCaseInsensitiveHashCodeProvider * self) {
	self->priv = SYSTEM_COLLECTIONS_CASE_INSENSITIVE_HASH_CODE_PROVIDER_GET_PRIVATE (self);
	self->ref_count = 1;
}


static void system_collections_case_insensitive_hash_code_provider_finalize (SystemCollectionsCaseInsensitiveHashCodeProvider* obj) {
	SystemCollectionsCaseInsensitiveHashCodeProvider * self;
	self = G_TYPE_CHECK_INSTANCE_CAST (obj, SYSTEM_COLLECTIONS_TYPE_CASE_INSENSITIVE_HASH_CODE_PROVIDER, SystemCollectionsCaseInsensitiveHashCodeProvider);
	g_signal_handlers_destroy (self);
}


GType system_collections_case_insensitive_hash_code_provider_get_type (void) {
	static volatile gsize system_collections_case_insensitive_hash_code_provider_type_id__volatile = 0;
	if (g_once_init_enter (&system_collections_case_insensitive_hash_code_provider_type_id__volatile)) {
		static const GTypeValueTable g_define_type_value_table = { system_collections_value_case_insensitive_hash_code_provider_init, system_collections_value_case_insensitive_hash_code_provider_free_value, system_collections_value_case_insensitive_hash_code_provider_copy_value, system_collections_value_case_insensitive_hash_code_provider_peek_pointer, "p", system_collections_value_case_insensitive_hash_code_provider_collect_value, "p", system_collections_value_case_insensitive_hash_code_provider_lcopy_value };
		static const GTypeInfo g_define_type_info = { sizeof (SystemCollectionsCaseInsensitiveHashCodeProviderClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) system_collections_case_insensitive_hash_code_provider_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (SystemCollectionsCaseInsensitiveHashCodeProvider), 0, (GInstanceInitFunc) system_collections_case_insensitive_hash_code_provider_instance_init, &g_define_type_value_table };
		static const GTypeFundamentalInfo g_define_type_fundamental_info = { (G_TYPE_FLAG_CLASSED | G_TYPE_FLAG_INSTANTIATABLE | G_TYPE_FLAG_DERIVABLE | G_TYPE_FLAG_DEEP_DERIVABLE) };
		static const GInterfaceInfo system_collections_ihash_code_provider_info = { (GInterfaceInitFunc) system_collections_case_insensitive_hash_code_provider_system_collections_ihash_code_provider_interface_init, (GInterfaceFinalizeFunc) NULL, NULL};
		GType system_collections_case_insensitive_hash_code_provider_type_id;
		system_collections_case_insensitive_hash_code_provider_type_id = g_type_register_fundamental (g_type_fundamental_next (), "SystemCollectionsCaseInsensitiveHashCodeProvider", &g_define_type_info, &g_define_type_fundamental_info, 0);
		g_type_add_interface_static (system_collections_case_insensitive_hash_code_provider_type_id, SYSTEM_COLLECTIONS_TYPE_IHASH_CODE_PROVIDER, &system_collections_ihash_code_provider_info);
		g_once_init_leave (&system_collections_case_insensitive_hash_code_provider_type_id__volatile, system_collections_case_insensitive_hash_code_provider_type_id);
	}
	return system_collections_case_insensitive_hash_code_provider_type_id__volatile;
}


gpointer system_collections_case_insensitive_hash_code_provider_ref (gpointer instance) {
	SystemCollectionsCaseInsensitiveHashCodeProvider* self;
	self = instance;
	g_atomic_int_inc (&self->ref_count);
	return instance;
}


void system_collections_case_insensitive_hash_code_provider_unref (gpointer instance) {
	SystemCollectionsCaseInsensitiveHashCodeProvider* self;
	self = instance;
	if (g_atomic_int_dec_and_test (&self->ref_count)) {
		SYSTEM_COLLECTIONS_CASE_INSENSITIVE_HASH_CODE_PROVIDER_GET_CLASS (self)->finalize (self);
		g_type_free_instance ((GTypeInstance *) self);
	}
}



