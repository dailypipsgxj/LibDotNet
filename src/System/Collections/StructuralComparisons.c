/* StructuralComparisons.c generated by valac 0.26.2, the Vala compiler
 * generated from StructuralComparisons.vala, do not modify */

/* Copyright (c) Microsoft. All rights reserved.*/
/* Licensed under the MIT license. See LICENSE file in the project root for full license information.*/
/* */

#include <glib.h>
#include <glib-object.h>
#include <gobject/gvaluecollector.h>


#define SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_COMPARISONS (system_collections_structural_comparisons_get_type ())
#define SYSTEM_COLLECTIONS_STRUCTURAL_COMPARISONS(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_COMPARISONS, SystemCollectionsStructuralComparisons))
#define SYSTEM_COLLECTIONS_STRUCTURAL_COMPARISONS_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_COMPARISONS, SystemCollectionsStructuralComparisonsClass))
#define SYSTEM_COLLECTIONS_IS_STRUCTURAL_COMPARISONS(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_COMPARISONS))
#define SYSTEM_COLLECTIONS_IS_STRUCTURAL_COMPARISONS_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_COMPARISONS))
#define SYSTEM_COLLECTIONS_STRUCTURAL_COMPARISONS_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_COMPARISONS, SystemCollectionsStructuralComparisonsClass))

typedef struct _SystemCollectionsStructuralComparisons SystemCollectionsStructuralComparisons;
typedef struct _SystemCollectionsStructuralComparisonsClass SystemCollectionsStructuralComparisonsClass;
typedef struct _SystemCollectionsStructuralComparisonsPrivate SystemCollectionsStructuralComparisonsPrivate;

#define SYSTEM_COLLECTIONS_TYPE_ICOMPARER (system_collections_icomparer_get_type ())
#define SYSTEM_COLLECTIONS_ICOMPARER(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_TYPE_ICOMPARER, SystemCollectionsIComparer))
#define SYSTEM_COLLECTIONS_IS_ICOMPARER(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_TYPE_ICOMPARER))
#define SYSTEM_COLLECTIONS_ICOMPARER_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_TYPE_ICOMPARER, SystemCollectionsIComparerIface))

typedef struct _SystemCollectionsIComparer SystemCollectionsIComparer;
typedef struct _SystemCollectionsIComparerIface SystemCollectionsIComparerIface;

#define SYSTEM_COLLECTIONS_TYPE_IEQUALITY_COMPARER (system_collections_iequality_comparer_get_type ())
#define SYSTEM_COLLECTIONS_IEQUALITY_COMPARER(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_TYPE_IEQUALITY_COMPARER, SystemCollectionsIEqualityComparer))
#define SYSTEM_COLLECTIONS_IS_IEQUALITY_COMPARER(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_TYPE_IEQUALITY_COMPARER))
#define SYSTEM_COLLECTIONS_IEQUALITY_COMPARER_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_TYPE_IEQUALITY_COMPARER, SystemCollectionsIEqualityComparerIface))

typedef struct _SystemCollectionsIEqualityComparer SystemCollectionsIEqualityComparer;
typedef struct _SystemCollectionsIEqualityComparerIface SystemCollectionsIEqualityComparerIface;

#define SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_COMPARERCLASS (system_collections_structural_comparerclass_get_type ())
#define SYSTEM_COLLECTIONS_STRUCTURAL_COMPARERCLASS(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_COMPARERCLASS, SystemCollectionsStructuralComparerClass))
#define SYSTEM_COLLECTIONS_STRUCTURAL_COMPARERCLASS_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_COMPARERCLASS, SystemCollectionsStructuralComparerClassClass))
#define SYSTEM_COLLECTIONS_IS_STRUCTURAL_COMPARERCLASS(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_COMPARERCLASS))
#define SYSTEM_COLLECTIONS_IS_STRUCTURAL_COMPARERCLASS_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_COMPARERCLASS))
#define SYSTEM_COLLECTIONS_STRUCTURAL_COMPARERCLASS_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_COMPARERCLASS, SystemCollectionsStructuralComparerClassClass))

typedef struct _SystemCollectionsStructuralComparerClass SystemCollectionsStructuralComparerClass;
typedef struct _SystemCollectionsStructuralComparerClassClass SystemCollectionsStructuralComparerClassClass;
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))

#define SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_EQUALITY_COMPARERCLASS (system_collections_structural_equality_comparerclass_get_type ())
#define SYSTEM_COLLECTIONS_STRUCTURAL_EQUALITY_COMPARERCLASS(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_EQUALITY_COMPARERCLASS, SystemCollectionsStructuralEqualityComparerClass))
#define SYSTEM_COLLECTIONS_STRUCTURAL_EQUALITY_COMPARERCLASS_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_EQUALITY_COMPARERCLASS, SystemCollectionsStructuralEqualityComparerClassClass))
#define SYSTEM_COLLECTIONS_IS_STRUCTURAL_EQUALITY_COMPARERCLASS(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_EQUALITY_COMPARERCLASS))
#define SYSTEM_COLLECTIONS_IS_STRUCTURAL_EQUALITY_COMPARERCLASS_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_EQUALITY_COMPARERCLASS))
#define SYSTEM_COLLECTIONS_STRUCTURAL_EQUALITY_COMPARERCLASS_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_EQUALITY_COMPARERCLASS, SystemCollectionsStructuralEqualityComparerClassClass))

typedef struct _SystemCollectionsStructuralEqualityComparerClass SystemCollectionsStructuralEqualityComparerClass;
typedef struct _SystemCollectionsStructuralEqualityComparerClassClass SystemCollectionsStructuralEqualityComparerClassClass;
typedef struct _SystemCollectionsParamSpecStructuralComparisons SystemCollectionsParamSpecStructuralComparisons;
typedef struct _SystemCollectionsStructuralEqualityComparerClassPrivate SystemCollectionsStructuralEqualityComparerClassPrivate;

#define SYSTEM_COLLECTIONS_TYPE_ISTRUCTURAL_EQUATABLE (system_collections_istructural_equatable_get_type ())
#define SYSTEM_COLLECTIONS_ISTRUCTURAL_EQUATABLE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_TYPE_ISTRUCTURAL_EQUATABLE, SystemCollectionsIStructuralEquatable))
#define SYSTEM_COLLECTIONS_IS_ISTRUCTURAL_EQUATABLE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_TYPE_ISTRUCTURAL_EQUATABLE))
#define SYSTEM_COLLECTIONS_ISTRUCTURAL_EQUATABLE_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_TYPE_ISTRUCTURAL_EQUATABLE, SystemCollectionsIStructuralEquatableIface))

typedef struct _SystemCollectionsIStructuralEquatable SystemCollectionsIStructuralEquatable;
typedef struct _SystemCollectionsIStructuralEquatableIface SystemCollectionsIStructuralEquatableIface;
typedef struct _SystemCollectionsStructuralComparerClassPrivate SystemCollectionsStructuralComparerClassPrivate;

#define SYSTEM_COLLECTIONS_TYPE_ISTRUCTURAL_COMPARABLE (system_collections_istructural_comparable_get_type ())
#define SYSTEM_COLLECTIONS_ISTRUCTURAL_COMPARABLE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_TYPE_ISTRUCTURAL_COMPARABLE, SystemCollectionsIStructuralComparable))
#define SYSTEM_COLLECTIONS_IS_ISTRUCTURAL_COMPARABLE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_TYPE_ISTRUCTURAL_COMPARABLE))
#define SYSTEM_COLLECTIONS_ISTRUCTURAL_COMPARABLE_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_TYPE_ISTRUCTURAL_COMPARABLE, SystemCollectionsIStructuralComparableIface))

typedef struct _SystemCollectionsIStructuralComparable SystemCollectionsIStructuralComparable;
typedef struct _SystemCollectionsIStructuralComparableIface SystemCollectionsIStructuralComparableIface;

#define SYSTEM_COLLECTIONS_TYPE_COMPARER (system_collections_comparer_get_type ())
#define SYSTEM_COLLECTIONS_COMPARER(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_TYPE_COMPARER, SystemCollectionsComparer))
#define SYSTEM_COLLECTIONS_COMPARER_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SYSTEM_COLLECTIONS_TYPE_COMPARER, SystemCollectionsComparerClass))
#define SYSTEM_COLLECTIONS_IS_COMPARER(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_TYPE_COMPARER))
#define SYSTEM_COLLECTIONS_IS_COMPARER_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SYSTEM_COLLECTIONS_TYPE_COMPARER))
#define SYSTEM_COLLECTIONS_COMPARER_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SYSTEM_COLLECTIONS_TYPE_COMPARER, SystemCollectionsComparerClass))

typedef struct _SystemCollectionsComparer SystemCollectionsComparer;
typedef struct _SystemCollectionsComparerClass SystemCollectionsComparerClass;

struct _SystemCollectionsStructuralComparisons {
	GTypeInstance parent_instance;
	volatile int ref_count;
	SystemCollectionsStructuralComparisonsPrivate * priv;
};

struct _SystemCollectionsStructuralComparisonsClass {
	GTypeClass parent_class;
	void (*finalize) (SystemCollectionsStructuralComparisons *self);
};

struct _SystemCollectionsIComparerIface {
	GTypeInterface parent_iface;
	gint (*Compare) (SystemCollectionsIComparer* self, GObject* x, GObject* y);
};

struct _SystemCollectionsIEqualityComparerIface {
	GTypeInterface parent_iface;
	gboolean (*Equals) (SystemCollectionsIEqualityComparer* self, GObject* x, GObject* y);
	gint (*GetHashCode) (SystemCollectionsIEqualityComparer* self, GObject* obj);
};

struct _SystemCollectionsParamSpecStructuralComparisons {
	GParamSpec parent_instance;
};

struct _SystemCollectionsStructuralEqualityComparerClass {
	GObject parent_instance;
	SystemCollectionsStructuralEqualityComparerClassPrivate * priv;
};

struct _SystemCollectionsStructuralEqualityComparerClassClass {
	GObjectClass parent_class;
};

struct _SystemCollectionsIStructuralEquatableIface {
	GTypeInterface parent_iface;
	gboolean (*Equals) (SystemCollectionsIStructuralEquatable* self, GObject* other, SystemCollectionsIEqualityComparer* comparer);
	gint (*GetHashCode) (SystemCollectionsIStructuralEquatable* self, SystemCollectionsIEqualityComparer* comparer);
};

struct _SystemCollectionsStructuralComparerClass {
	GObject parent_instance;
	SystemCollectionsStructuralComparerClassPrivate * priv;
};

struct _SystemCollectionsStructuralComparerClassClass {
	GObjectClass parent_class;
};

struct _SystemCollectionsIStructuralComparableIface {
	GTypeInterface parent_iface;
	gint32 (*CompareTo) (SystemCollectionsIStructuralComparable* self, GObject* other, SystemCollectionsIComparer* comparer);
};


static gpointer system_collections_structural_comparisons_parent_class = NULL;
static SystemCollectionsIComparer* system_collections_structural_comparisons_s_StructuralComparer;
static SystemCollectionsIComparer* system_collections_structural_comparisons_s_StructuralComparer = NULL;
static SystemCollectionsIEqualityComparer* system_collections_structural_comparisons_s_StructuralEqualityComparer;
static SystemCollectionsIEqualityComparer* system_collections_structural_comparisons_s_StructuralEqualityComparer = NULL;
static gpointer system_collections_structural_equality_comparerclass_parent_class = NULL;
static SystemCollectionsIEqualityComparerIface* system_collections_structural_equality_comparerclass_system_collections_iequality_comparer_parent_iface = NULL;
static gpointer system_collections_structural_comparerclass_parent_class = NULL;
extern SystemCollectionsComparer* system_collections_comparer_Default;
static SystemCollectionsIComparerIface* system_collections_structural_comparerclass_system_collections_icomparer_parent_iface = NULL;

gpointer system_collections_structural_comparisons_ref (gpointer instance);
void system_collections_structural_comparisons_unref (gpointer instance);
GParamSpec* system_collections_param_spec_structural_comparisons (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void system_collections_value_set_structural_comparisons (GValue* value, gpointer v_object);
void system_collections_value_take_structural_comparisons (GValue* value, gpointer v_object);
gpointer system_collections_value_get_structural_comparisons (const GValue* value);
GType system_collections_structural_comparisons_get_type (void) G_GNUC_CONST;
enum  {
	SYSTEM_COLLECTIONS_STRUCTURAL_COMPARISONS_DUMMY_PROPERTY
};
GType system_collections_icomparer_get_type (void) G_GNUC_CONST;
GType system_collections_iequality_comparer_get_type (void) G_GNUC_CONST;
SystemCollectionsStructuralComparisons* system_collections_structural_comparisons_new (void);
SystemCollectionsStructuralComparisons* system_collections_structural_comparisons_construct (GType object_type);
SystemCollectionsIComparer* system_collections_structural_comparisons_get_StructuralComparer (void);
SystemCollectionsStructuralComparerClass* system_collections_structural_comparerclass_new (void);
SystemCollectionsStructuralComparerClass* system_collections_structural_comparerclass_construct (GType object_type);
GType system_collections_structural_comparerclass_get_type (void) G_GNUC_CONST;
SystemCollectionsIEqualityComparer* system_collections_structural_comparisons_get_StructuralEqualityComparer (void);
SystemCollectionsStructuralEqualityComparerClass* system_collections_structural_equality_comparerclass_new (void);
SystemCollectionsStructuralEqualityComparerClass* system_collections_structural_equality_comparerclass_construct (GType object_type);
GType system_collections_structural_equality_comparerclass_get_type (void) G_GNUC_CONST;
static void system_collections_structural_comparisons_finalize (SystemCollectionsStructuralComparisons* obj);
enum  {
	SYSTEM_COLLECTIONS_STRUCTURAL_EQUALITY_COMPARERCLASS_DUMMY_PROPERTY
};
static gboolean system_collections_structural_equality_comparerclass_real_Equals (SystemCollectionsIEqualityComparer* base, GObject* x, GObject* y);
static gint system_collections_structural_equality_comparerclass_real_GetHashCode (SystemCollectionsIEqualityComparer* base, GObject* obj);
GType system_collections_istructural_equatable_get_type (void) G_GNUC_CONST;
gint system_collections_istructural_equatable_GetHashCode (SystemCollectionsIStructuralEquatable* self, SystemCollectionsIEqualityComparer* comparer);
enum  {
	SYSTEM_COLLECTIONS_STRUCTURAL_COMPARERCLASS_DUMMY_PROPERTY
};
static gint system_collections_structural_comparerclass_real_Compare (SystemCollectionsIComparer* base, GObject* x, GObject* y);
GType system_collections_istructural_comparable_get_type (void) G_GNUC_CONST;
gint32 system_collections_istructural_comparable_CompareTo (SystemCollectionsIStructuralComparable* self, GObject* other, SystemCollectionsIComparer* comparer);
GType system_collections_comparer_get_type (void) G_GNUC_CONST;
gint system_collections_icomparer_Compare (SystemCollectionsIComparer* self, GObject* x, GObject* y);


SystemCollectionsStructuralComparisons* system_collections_structural_comparisons_construct (GType object_type) {
	SystemCollectionsStructuralComparisons* self = NULL;
	self = (SystemCollectionsStructuralComparisons*) g_type_create_instance (object_type);
	return self;
}


SystemCollectionsStructuralComparisons* system_collections_structural_comparisons_new (void) {
	return system_collections_structural_comparisons_construct (SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_COMPARISONS);
}


static gpointer _g_object_ref0 (gpointer self) {
	return self ? g_object_ref (self) : NULL;
}


SystemCollectionsIComparer* system_collections_structural_comparisons_get_StructuralComparer (void) {
	SystemCollectionsIComparer* result;
	SystemCollectionsIComparer* comparer = NULL;
	SystemCollectionsIComparer* _tmp0_ = NULL;
	SystemCollectionsIComparer* _tmp1_ = NULL;
	SystemCollectionsIComparer* _tmp2_ = NULL;
	_tmp0_ = system_collections_structural_comparisons_s_StructuralComparer;
	_tmp1_ = _g_object_ref0 (_tmp0_);
	comparer = _tmp1_;
	_tmp2_ = comparer;
	if (_tmp2_ == NULL) {
		SystemCollectionsStructuralComparerClass* _tmp3_ = NULL;
		SystemCollectionsIComparer* _tmp4_ = NULL;
		SystemCollectionsIComparer* _tmp5_ = NULL;
		_tmp3_ = system_collections_structural_comparerclass_new ();
		_g_object_unref0 (comparer);
		comparer = (SystemCollectionsIComparer*) _tmp3_;
		_tmp4_ = comparer;
		_tmp5_ = _g_object_ref0 (_tmp4_);
		_g_object_unref0 (system_collections_structural_comparisons_s_StructuralComparer);
		system_collections_structural_comparisons_s_StructuralComparer = _tmp5_;
	}
	result = comparer;
	return result;
}


SystemCollectionsIEqualityComparer* system_collections_structural_comparisons_get_StructuralEqualityComparer (void) {
	SystemCollectionsIEqualityComparer* result;
	SystemCollectionsIEqualityComparer* comparer = NULL;
	SystemCollectionsIEqualityComparer* _tmp0_ = NULL;
	SystemCollectionsIEqualityComparer* _tmp1_ = NULL;
	SystemCollectionsIEqualityComparer* _tmp2_ = NULL;
	_tmp0_ = system_collections_structural_comparisons_s_StructuralEqualityComparer;
	_tmp1_ = _g_object_ref0 (_tmp0_);
	comparer = _tmp1_;
	_tmp2_ = comparer;
	if (_tmp2_ == NULL) {
		SystemCollectionsStructuralEqualityComparerClass* _tmp3_ = NULL;
		SystemCollectionsIEqualityComparer* _tmp4_ = NULL;
		SystemCollectionsIEqualityComparer* _tmp5_ = NULL;
		_tmp3_ = system_collections_structural_equality_comparerclass_new ();
		_g_object_unref0 (comparer);
		comparer = (SystemCollectionsIEqualityComparer*) _tmp3_;
		_tmp4_ = comparer;
		_tmp5_ = _g_object_ref0 (_tmp4_);
		_g_object_unref0 (system_collections_structural_comparisons_s_StructuralEqualityComparer);
		system_collections_structural_comparisons_s_StructuralEqualityComparer = _tmp5_;
	}
	result = comparer;
	return result;
}


static void system_collections_value_structural_comparisons_init (GValue* value) {
	value->data[0].v_pointer = NULL;
}


static void system_collections_value_structural_comparisons_free_value (GValue* value) {
	if (value->data[0].v_pointer) {
		system_collections_structural_comparisons_unref (value->data[0].v_pointer);
	}
}


static void system_collections_value_structural_comparisons_copy_value (const GValue* src_value, GValue* dest_value) {
	if (src_value->data[0].v_pointer) {
		dest_value->data[0].v_pointer = system_collections_structural_comparisons_ref (src_value->data[0].v_pointer);
	} else {
		dest_value->data[0].v_pointer = NULL;
	}
}


static gpointer system_collections_value_structural_comparisons_peek_pointer (const GValue* value) {
	return value->data[0].v_pointer;
}


static gchar* system_collections_value_structural_comparisons_collect_value (GValue* value, guint n_collect_values, GTypeCValue* collect_values, guint collect_flags) {
	if (collect_values[0].v_pointer) {
		SystemCollectionsStructuralComparisons* object;
		object = collect_values[0].v_pointer;
		if (object->parent_instance.g_class == NULL) {
			return g_strconcat ("invalid unclassed object pointer for value type `", G_VALUE_TYPE_NAME (value), "'", NULL);
		} else if (!g_value_type_compatible (G_TYPE_FROM_INSTANCE (object), G_VALUE_TYPE (value))) {
			return g_strconcat ("invalid object type `", g_type_name (G_TYPE_FROM_INSTANCE (object)), "' for value type `", G_VALUE_TYPE_NAME (value), "'", NULL);
		}
		value->data[0].v_pointer = system_collections_structural_comparisons_ref (object);
	} else {
		value->data[0].v_pointer = NULL;
	}
	return NULL;
}


static gchar* system_collections_value_structural_comparisons_lcopy_value (const GValue* value, guint n_collect_values, GTypeCValue* collect_values, guint collect_flags) {
	SystemCollectionsStructuralComparisons** object_p;
	object_p = collect_values[0].v_pointer;
	if (!object_p) {
		return g_strdup_printf ("value location for `%s' passed as NULL", G_VALUE_TYPE_NAME (value));
	}
	if (!value->data[0].v_pointer) {
		*object_p = NULL;
	} else if (collect_flags & G_VALUE_NOCOPY_CONTENTS) {
		*object_p = value->data[0].v_pointer;
	} else {
		*object_p = system_collections_structural_comparisons_ref (value->data[0].v_pointer);
	}
	return NULL;
}


GParamSpec* system_collections_param_spec_structural_comparisons (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags) {
	SystemCollectionsParamSpecStructuralComparisons* spec;
	g_return_val_if_fail (g_type_is_a (object_type, SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_COMPARISONS), NULL);
	spec = g_param_spec_internal (G_TYPE_PARAM_OBJECT, name, nick, blurb, flags);
	G_PARAM_SPEC (spec)->value_type = object_type;
	return G_PARAM_SPEC (spec);
}


gpointer system_collections_value_get_structural_comparisons (const GValue* value) {
	g_return_val_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_COMPARISONS), NULL);
	return value->data[0].v_pointer;
}


void system_collections_value_set_structural_comparisons (GValue* value, gpointer v_object) {
	SystemCollectionsStructuralComparisons* old;
	g_return_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_COMPARISONS));
	old = value->data[0].v_pointer;
	if (v_object) {
		g_return_if_fail (G_TYPE_CHECK_INSTANCE_TYPE (v_object, SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_COMPARISONS));
		g_return_if_fail (g_value_type_compatible (G_TYPE_FROM_INSTANCE (v_object), G_VALUE_TYPE (value)));
		value->data[0].v_pointer = v_object;
		system_collections_structural_comparisons_ref (value->data[0].v_pointer);
	} else {
		value->data[0].v_pointer = NULL;
	}
	if (old) {
		system_collections_structural_comparisons_unref (old);
	}
}


void system_collections_value_take_structural_comparisons (GValue* value, gpointer v_object) {
	SystemCollectionsStructuralComparisons* old;
	g_return_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_COMPARISONS));
	old = value->data[0].v_pointer;
	if (v_object) {
		g_return_if_fail (G_TYPE_CHECK_INSTANCE_TYPE (v_object, SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_COMPARISONS));
		g_return_if_fail (g_value_type_compatible (G_TYPE_FROM_INSTANCE (v_object), G_VALUE_TYPE (value)));
		value->data[0].v_pointer = v_object;
	} else {
		value->data[0].v_pointer = NULL;
	}
	if (old) {
		system_collections_structural_comparisons_unref (old);
	}
}


static void system_collections_structural_comparisons_class_init (SystemCollectionsStructuralComparisonsClass * klass) {
	system_collections_structural_comparisons_parent_class = g_type_class_peek_parent (klass);
	((SystemCollectionsStructuralComparisonsClass *) klass)->finalize = system_collections_structural_comparisons_finalize;
}


static void system_collections_structural_comparisons_instance_init (SystemCollectionsStructuralComparisons * self) {
	self->ref_count = 1;
}


static void system_collections_structural_comparisons_finalize (SystemCollectionsStructuralComparisons* obj) {
	SystemCollectionsStructuralComparisons * self;
	self = G_TYPE_CHECK_INSTANCE_CAST (obj, SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_COMPARISONS, SystemCollectionsStructuralComparisons);
	g_signal_handlers_destroy (self);
}


GType system_collections_structural_comparisons_get_type (void) {
	static volatile gsize system_collections_structural_comparisons_type_id__volatile = 0;
	if (g_once_init_enter (&system_collections_structural_comparisons_type_id__volatile)) {
		static const GTypeValueTable g_define_type_value_table = { system_collections_value_structural_comparisons_init, system_collections_value_structural_comparisons_free_value, system_collections_value_structural_comparisons_copy_value, system_collections_value_structural_comparisons_peek_pointer, "p", system_collections_value_structural_comparisons_collect_value, "p", system_collections_value_structural_comparisons_lcopy_value };
		static const GTypeInfo g_define_type_info = { sizeof (SystemCollectionsStructuralComparisonsClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) system_collections_structural_comparisons_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (SystemCollectionsStructuralComparisons), 0, (GInstanceInitFunc) system_collections_structural_comparisons_instance_init, &g_define_type_value_table };
		static const GTypeFundamentalInfo g_define_type_fundamental_info = { (G_TYPE_FLAG_CLASSED | G_TYPE_FLAG_INSTANTIATABLE | G_TYPE_FLAG_DERIVABLE | G_TYPE_FLAG_DEEP_DERIVABLE) };
		GType system_collections_structural_comparisons_type_id;
		system_collections_structural_comparisons_type_id = g_type_register_fundamental (g_type_fundamental_next (), "SystemCollectionsStructuralComparisons", &g_define_type_info, &g_define_type_fundamental_info, 0);
		g_once_init_leave (&system_collections_structural_comparisons_type_id__volatile, system_collections_structural_comparisons_type_id);
	}
	return system_collections_structural_comparisons_type_id__volatile;
}


gpointer system_collections_structural_comparisons_ref (gpointer instance) {
	SystemCollectionsStructuralComparisons* self;
	self = instance;
	g_atomic_int_inc (&self->ref_count);
	return instance;
}


void system_collections_structural_comparisons_unref (gpointer instance) {
	SystemCollectionsStructuralComparisons* self;
	self = instance;
	if (g_atomic_int_dec_and_test (&self->ref_count)) {
		SYSTEM_COLLECTIONS_STRUCTURAL_COMPARISONS_GET_CLASS (self)->finalize (self);
		g_type_free_instance ((GTypeInstance *) self);
	}
}


static gboolean system_collections_structural_equality_comparerclass_real_Equals (SystemCollectionsIEqualityComparer* base, GObject* x, GObject* y) {
	SystemCollectionsStructuralEqualityComparerClass * self;
	gboolean result = FALSE;
	GObject* _tmp0_ = NULL;
	self = (SystemCollectionsStructuralEqualityComparerClass*) base;
	g_return_val_if_fail (x != NULL, FALSE);
	g_return_val_if_fail (y != NULL, FALSE);
	_tmp0_ = y;
	if (_tmp0_ != NULL) {
		result = FALSE;
		return result;
	}
	result = TRUE;
	return result;
}


static gint system_collections_structural_equality_comparerclass_real_GetHashCode (SystemCollectionsIEqualityComparer* base, GObject* obj) {
	SystemCollectionsStructuralEqualityComparerClass * self;
	gint result = 0;
	GObject* _tmp0_ = NULL;
	SystemCollectionsIStructuralEquatable* seObj = NULL;
	GObject* _tmp1_ = NULL;
	SystemCollectionsIStructuralEquatable* _tmp2_ = NULL;
	SystemCollectionsIStructuralEquatable* _tmp3_ = NULL;
	self = (SystemCollectionsStructuralEqualityComparerClass*) base;
	g_return_val_if_fail (obj != NULL, 0);
	_tmp0_ = obj;
	if (_tmp0_ == NULL) {
		result = 0;
		return result;
	}
	_tmp1_ = obj;
	_tmp2_ = _g_object_ref0 (G_TYPE_CHECK_INSTANCE_TYPE (_tmp1_, SYSTEM_COLLECTIONS_TYPE_ISTRUCTURAL_EQUATABLE) ? ((SystemCollectionsIStructuralEquatable*) _tmp1_) : NULL);
	seObj = _tmp2_;
	_tmp3_ = seObj;
	if (_tmp3_ != NULL) {
		SystemCollectionsIStructuralEquatable* _tmp4_ = NULL;
		gint _tmp5_ = 0;
		_tmp4_ = seObj;
		_tmp5_ = system_collections_istructural_equatable_GetHashCode (_tmp4_, (SystemCollectionsIEqualityComparer*) self);
		result = _tmp5_;
		_g_object_unref0 (seObj);
		return result;
	}
	result = -1;
	_g_object_unref0 (seObj);
	return result;
}


SystemCollectionsStructuralEqualityComparerClass* system_collections_structural_equality_comparerclass_construct (GType object_type) {
	SystemCollectionsStructuralEqualityComparerClass * self = NULL;
	self = (SystemCollectionsStructuralEqualityComparerClass*) g_object_new (object_type, NULL);
	return self;
}


SystemCollectionsStructuralEqualityComparerClass* system_collections_structural_equality_comparerclass_new (void) {
	return system_collections_structural_equality_comparerclass_construct (SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_EQUALITY_COMPARERCLASS);
}


static void system_collections_structural_equality_comparerclass_class_init (SystemCollectionsStructuralEqualityComparerClassClass * klass) {
	system_collections_structural_equality_comparerclass_parent_class = g_type_class_peek_parent (klass);
}


static void system_collections_structural_equality_comparerclass_system_collections_iequality_comparer_interface_init (SystemCollectionsIEqualityComparerIface * iface) {
	system_collections_structural_equality_comparerclass_system_collections_iequality_comparer_parent_iface = g_type_interface_peek_parent (iface);
	iface->Equals = (gboolean (*)(SystemCollectionsIEqualityComparer*, GObject*, GObject*)) system_collections_structural_equality_comparerclass_real_Equals;
	iface->GetHashCode = (gint (*)(SystemCollectionsIEqualityComparer*, GObject*)) system_collections_structural_equality_comparerclass_real_GetHashCode;
}


static void system_collections_structural_equality_comparerclass_instance_init (SystemCollectionsStructuralEqualityComparerClass * self) {
}


GType system_collections_structural_equality_comparerclass_get_type (void) {
	static volatile gsize system_collections_structural_equality_comparerclass_type_id__volatile = 0;
	if (g_once_init_enter (&system_collections_structural_equality_comparerclass_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (SystemCollectionsStructuralEqualityComparerClassClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) system_collections_structural_equality_comparerclass_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (SystemCollectionsStructuralEqualityComparerClass), 0, (GInstanceInitFunc) system_collections_structural_equality_comparerclass_instance_init, NULL };
		static const GInterfaceInfo system_collections_iequality_comparer_info = { (GInterfaceInitFunc) system_collections_structural_equality_comparerclass_system_collections_iequality_comparer_interface_init, (GInterfaceFinalizeFunc) NULL, NULL};
		GType system_collections_structural_equality_comparerclass_type_id;
		system_collections_structural_equality_comparerclass_type_id = g_type_register_static (G_TYPE_OBJECT, "SystemCollectionsStructuralEqualityComparerClass", &g_define_type_info, 0);
		g_type_add_interface_static (system_collections_structural_equality_comparerclass_type_id, SYSTEM_COLLECTIONS_TYPE_IEQUALITY_COMPARER, &system_collections_iequality_comparer_info);
		g_once_init_leave (&system_collections_structural_equality_comparerclass_type_id__volatile, system_collections_structural_equality_comparerclass_type_id);
	}
	return system_collections_structural_equality_comparerclass_type_id__volatile;
}


static gint system_collections_structural_comparerclass_real_Compare (SystemCollectionsIComparer* base, GObject* x, GObject* y) {
	SystemCollectionsStructuralComparerClass * self;
	gint result = 0;
	GObject* _tmp0_ = NULL;
	GObject* _tmp3_ = NULL;
	SystemCollectionsIStructuralComparable* scX = NULL;
	GObject* _tmp4_ = NULL;
	SystemCollectionsIStructuralComparable* _tmp5_ = NULL;
	SystemCollectionsIStructuralComparable* _tmp6_ = NULL;
	SystemCollectionsComparer* _tmp10_ = NULL;
	GObject* _tmp11_ = NULL;
	GObject* _tmp12_ = NULL;
	gint _tmp13_ = 0;
	self = (SystemCollectionsStructuralComparerClass*) base;
	g_return_val_if_fail (x != NULL, 0);
	g_return_val_if_fail (y != NULL, 0);
	_tmp0_ = x;
	if (_tmp0_ == NULL) {
		gint _tmp1_ = 0;
		GObject* _tmp2_ = NULL;
		_tmp2_ = y;
		if (_tmp2_ == NULL) {
			_tmp1_ = 0;
		} else {
			_tmp1_ = -1;
		}
		result = _tmp1_;
		return result;
	}
	_tmp3_ = y;
	if (_tmp3_ == NULL) {
		result = 1;
		return result;
	}
	_tmp4_ = x;
	_tmp5_ = _g_object_ref0 (G_TYPE_CHECK_INSTANCE_TYPE (_tmp4_, SYSTEM_COLLECTIONS_TYPE_ISTRUCTURAL_COMPARABLE) ? ((SystemCollectionsIStructuralComparable*) _tmp4_) : NULL);
	scX = _tmp5_;
	_tmp6_ = scX;
	if (_tmp6_ != NULL) {
		SystemCollectionsIStructuralComparable* _tmp7_ = NULL;
		GObject* _tmp8_ = NULL;
		gint32 _tmp9_ = 0;
		_tmp7_ = scX;
		_tmp8_ = y;
		_tmp9_ = system_collections_istructural_comparable_CompareTo (_tmp7_, _tmp8_, (SystemCollectionsIComparer*) self);
		result = (gint) _tmp9_;
		_g_object_unref0 (scX);
		return result;
	}
	_tmp10_ = system_collections_comparer_Default;
	_tmp11_ = x;
	_tmp12_ = y;
	_tmp13_ = system_collections_icomparer_Compare ((SystemCollectionsIComparer*) _tmp10_, _tmp11_, _tmp12_);
	result = _tmp13_;
	_g_object_unref0 (scX);
	return result;
}


SystemCollectionsStructuralComparerClass* system_collections_structural_comparerclass_construct (GType object_type) {
	SystemCollectionsStructuralComparerClass * self = NULL;
	self = (SystemCollectionsStructuralComparerClass*) g_object_new (object_type, NULL);
	return self;
}


SystemCollectionsStructuralComparerClass* system_collections_structural_comparerclass_new (void) {
	return system_collections_structural_comparerclass_construct (SYSTEM_COLLECTIONS_TYPE_STRUCTURAL_COMPARERCLASS);
}


static void system_collections_structural_comparerclass_class_init (SystemCollectionsStructuralComparerClassClass * klass) {
	system_collections_structural_comparerclass_parent_class = g_type_class_peek_parent (klass);
}


static void system_collections_structural_comparerclass_system_collections_icomparer_interface_init (SystemCollectionsIComparerIface * iface) {
	system_collections_structural_comparerclass_system_collections_icomparer_parent_iface = g_type_interface_peek_parent (iface);
	iface->Compare = (gint (*)(SystemCollectionsIComparer*, GObject*, GObject*)) system_collections_structural_comparerclass_real_Compare;
}


static void system_collections_structural_comparerclass_instance_init (SystemCollectionsStructuralComparerClass * self) {
}


GType system_collections_structural_comparerclass_get_type (void) {
	static volatile gsize system_collections_structural_comparerclass_type_id__volatile = 0;
	if (g_once_init_enter (&system_collections_structural_comparerclass_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (SystemCollectionsStructuralComparerClassClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) system_collections_structural_comparerclass_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (SystemCollectionsStructuralComparerClass), 0, (GInstanceInitFunc) system_collections_structural_comparerclass_instance_init, NULL };
		static const GInterfaceInfo system_collections_icomparer_info = { (GInterfaceInitFunc) system_collections_structural_comparerclass_system_collections_icomparer_interface_init, (GInterfaceFinalizeFunc) NULL, NULL};
		GType system_collections_structural_comparerclass_type_id;
		system_collections_structural_comparerclass_type_id = g_type_register_static (G_TYPE_OBJECT, "SystemCollectionsStructuralComparerClass", &g_define_type_info, 0);
		g_type_add_interface_static (system_collections_structural_comparerclass_type_id, SYSTEM_COLLECTIONS_TYPE_ICOMPARER, &system_collections_icomparer_info);
		g_once_init_leave (&system_collections_structural_comparerclass_type_id__volatile, system_collections_structural_comparerclass_type_id);
	}
	return system_collections_structural_comparerclass_type_id__volatile;
}



