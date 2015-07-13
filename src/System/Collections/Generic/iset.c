/* iset.c generated by valac 0.26.2, the Vala compiler
 * generated from iset.vala, do not modify */

/* ==++==*/
/* */
/*   Copyright (c) Microsoft Corporation.  All rights reserved.*/
/* */
/* ==--==*/
/*============================================================
**
** Interface:  ISet
** 
** <OWNER>[....]</OWNER>
**
**
** Purpose: Base interface for all generic sets.
**
** 
===========================================================*/

#include <glib.h>
#include <glib-object.h>
#include <gee.h>


#define SYSTEM_COLLECTIONS_TYPE_IENUMERABLE (system_collections_ienumerable_get_type ())
#define SYSTEM_COLLECTIONS_IENUMERABLE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_TYPE_IENUMERABLE, SystemCollectionsIEnumerable))
#define SYSTEM_COLLECTIONS_IS_IENUMERABLE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_TYPE_IENUMERABLE))
#define SYSTEM_COLLECTIONS_IENUMERABLE_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_TYPE_IENUMERABLE, SystemCollectionsIEnumerableIface))

typedef struct _SystemCollectionsIEnumerable SystemCollectionsIEnumerable;
typedef struct _SystemCollectionsIEnumerableIface SystemCollectionsIEnumerableIface;

#define SYSTEM_COLLECTIONS_TYPE_IENUMERATOR (system_collections_ienumerator_get_type ())
#define SYSTEM_COLLECTIONS_IENUMERATOR(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_TYPE_IENUMERATOR, SystemCollectionsIEnumerator))
#define SYSTEM_COLLECTIONS_IS_IENUMERATOR(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_TYPE_IENUMERATOR))
#define SYSTEM_COLLECTIONS_IENUMERATOR_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_TYPE_IENUMERATOR, SystemCollectionsIEnumeratorIface))

typedef struct _SystemCollectionsIEnumerator SystemCollectionsIEnumerator;
typedef struct _SystemCollectionsIEnumeratorIface SystemCollectionsIEnumeratorIface;

#define SYSTEM_COLLECTIONS_GENERIC_TYPE_IENUMERABLE (system_collections_generic_ienumerable_get_type ())
#define SYSTEM_COLLECTIONS_GENERIC_IENUMERABLE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_IENUMERABLE, SystemCollectionsGenericIEnumerable))
#define SYSTEM_COLLECTIONS_GENERIC_IS_IENUMERABLE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_IENUMERABLE))
#define SYSTEM_COLLECTIONS_GENERIC_IENUMERABLE_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_IENUMERABLE, SystemCollectionsGenericIEnumerableIface))

typedef struct _SystemCollectionsGenericIEnumerable SystemCollectionsGenericIEnumerable;
typedef struct _SystemCollectionsGenericIEnumerableIface SystemCollectionsGenericIEnumerableIface;

#define SYSTEM_TYPE_IDISPOSABLE (system_idisposable_get_type ())
#define SYSTEM_IDISPOSABLE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_TYPE_IDISPOSABLE, SystemIDisposable))
#define SYSTEM_IS_IDISPOSABLE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_TYPE_IDISPOSABLE))
#define SYSTEM_IDISPOSABLE_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_TYPE_IDISPOSABLE, SystemIDisposableIface))

typedef struct _SystemIDisposable SystemIDisposable;
typedef struct _SystemIDisposableIface SystemIDisposableIface;

#define SYSTEM_COLLECTIONS_GENERIC_TYPE_IENUMERATOR (system_collections_generic_ienumerator_get_type ())
#define SYSTEM_COLLECTIONS_GENERIC_IENUMERATOR(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_IENUMERATOR, SystemCollectionsGenericIEnumerator))
#define SYSTEM_COLLECTIONS_GENERIC_IS_IENUMERATOR(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_IENUMERATOR))
#define SYSTEM_COLLECTIONS_GENERIC_IENUMERATOR_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_IENUMERATOR, SystemCollectionsGenericIEnumeratorIface))

typedef struct _SystemCollectionsGenericIEnumerator SystemCollectionsGenericIEnumerator;
typedef struct _SystemCollectionsGenericIEnumeratorIface SystemCollectionsGenericIEnumeratorIface;

#define SYSTEM_COLLECTIONS_GENERIC_TYPE_ICOLLECTION (system_collections_generic_icollection_get_type ())
#define SYSTEM_COLLECTIONS_GENERIC_ICOLLECTION(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_ICOLLECTION, SystemCollectionsGenericICollection))
#define SYSTEM_COLLECTIONS_GENERIC_IS_ICOLLECTION(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_ICOLLECTION))
#define SYSTEM_COLLECTIONS_GENERIC_ICOLLECTION_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_ICOLLECTION, SystemCollectionsGenericICollectionIface))

typedef struct _SystemCollectionsGenericICollection SystemCollectionsGenericICollection;
typedef struct _SystemCollectionsGenericICollectionIface SystemCollectionsGenericICollectionIface;

#define SYSTEM_COLLECTIONS_GENERIC_TYPE_ISET (system_collections_generic_iset_get_type ())
#define SYSTEM_COLLECTIONS_GENERIC_ISET(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_ISET, SystemCollectionsGenericISet))
#define SYSTEM_COLLECTIONS_GENERIC_IS_ISET(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_ISET))
#define SYSTEM_COLLECTIONS_GENERIC_ISET_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_ISET, SystemCollectionsGenericISetIface))

typedef struct _SystemCollectionsGenericISet SystemCollectionsGenericISet;
typedef struct _SystemCollectionsGenericISetIface SystemCollectionsGenericISetIface;

struct _SystemCollectionsIEnumeratorIface {
	GTypeInterface parent_iface;
	gboolean (*MoveNext) (SystemCollectionsIEnumerator* self);
	gboolean (*next) (SystemCollectionsIEnumerator* self);
	GObject* (*get) (SystemCollectionsIEnumerator* self);
	void (*Reset) (SystemCollectionsIEnumerator* self);
	GObject* (*get__currentElement) (SystemCollectionsIEnumerator* self);
	void (*set__currentElement) (SystemCollectionsIEnumerator* self, GObject* value);
	GeeIterator* (*get__iterator) (SystemCollectionsIEnumerator* self);
	void (*set__iterator) (SystemCollectionsIEnumerator* self, GeeIterator* value);
	GObject* (*get_Current) (SystemCollectionsIEnumerator* self);
};

struct _SystemCollectionsIEnumerableIface {
	GTypeInterface parent_iface;
	SystemCollectionsIEnumerator* (*GetEnumerator) (SystemCollectionsIEnumerable* self);
};

struct _SystemIDisposableIface {
	GTypeInterface parent_iface;
	void (*Dispose) (SystemIDisposable* self);
};

struct _SystemCollectionsGenericIEnumeratorIface {
	GTypeInterface parent_iface;
	gconstpointer (*get_Current) (SystemCollectionsGenericIEnumerator* self);
};

struct _SystemCollectionsGenericIEnumerableIface {
	GTypeInterface parent_iface;
	SystemCollectionsGenericIEnumerator* (*GetEnumerator) (SystemCollectionsGenericIEnumerable* self);
};

struct _SystemCollectionsGenericICollectionIface {
	GTypeInterface parent_iface;
	GType (*get_t_type) (SystemCollectionsGenericICollection* self);
	GBoxedCopyFunc (*get_t_dup_func) (SystemCollectionsGenericICollection* self);
	GDestroyNotify (*get_t_destroy_func) (SystemCollectionsGenericICollection* self);
	void (*Add) (SystemCollectionsGenericICollection* self, gconstpointer item);
	void (*Clear) (SystemCollectionsGenericICollection* self);
	gboolean (*Contains) (SystemCollectionsGenericICollection* self, gconstpointer item);
	void (*CopyTo) (SystemCollectionsGenericICollection* self, gpointer* array, int array_length1, gint arrayIndex);
	gboolean (*Remove) (SystemCollectionsGenericICollection* self, gconstpointer item);
	gint (*get_Count) (SystemCollectionsGenericICollection* self);
	gboolean (*get_IsReadOnly) (SystemCollectionsGenericICollection* self);
};

struct _SystemCollectionsGenericISetIface {
	GTypeInterface parent_iface;
	gboolean (*Add) (SystemCollectionsGenericISet* self, gconstpointer value);
	void (*ExceptWith) (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other);
	void (*IntersectWith) (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other);
	gboolean (*IsProperSupersetOf) (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other);
	gboolean (*IsProperSubsetOf) (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other);
	gboolean (*IsSubsetOf) (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other);
	gboolean (*IsSupersetOf) (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other);
	gboolean (*Overlaps) (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other);
	gboolean (*SetEquals) (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other);
	void (*SymmetricExceptWith) (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other);
	void (*UnionWith) (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other);
};



GType system_collections_ienumerator_get_type (void) G_GNUC_CONST;
GType system_collections_ienumerable_get_type (void) G_GNUC_CONST;
GType system_idisposable_get_type (void) G_GNUC_CONST;
GType system_collections_generic_ienumerator_get_type (void) G_GNUC_CONST;
GType system_collections_generic_ienumerable_get_type (void) G_GNUC_CONST;
GType system_collections_generic_icollection_get_type (void) G_GNUC_CONST;
GType system_collections_generic_iset_get_type (void) G_GNUC_CONST;
gboolean system_collections_generic_iset_Add (SystemCollectionsGenericISet* self, gconstpointer value);
static gboolean system_collections_generic_iset_real_Add (SystemCollectionsGenericISet* self, gconstpointer value);
void system_collections_generic_iset_ExceptWith (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other);
void system_collections_generic_iset_IntersectWith (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other);
gboolean system_collections_generic_iset_IsProperSupersetOf (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other);
gboolean system_collections_generic_iset_IsProperSubsetOf (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other);
gboolean system_collections_generic_iset_IsSubsetOf (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other);
gboolean system_collections_generic_iset_IsSupersetOf (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other);
gboolean system_collections_generic_iset_Overlaps (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other);
gboolean system_collections_generic_iset_SetEquals (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other);
void system_collections_generic_iset_SymmetricExceptWith (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other);
void system_collections_generic_iset_UnionWith (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other);


static gboolean system_collections_generic_iset_real_Add (SystemCollectionsGenericISet* self, gconstpointer value) {
	gboolean result = FALSE;
	gconstpointer _tmp0_ = NULL;
	gboolean _tmp1_ = FALSE;
	_tmp0_ = value;
	_tmp1_ = gee_collection_add ((GeeCollection*) self, _tmp0_);
	result = _tmp1_;
	return result;
}


gboolean system_collections_generic_iset_Add (SystemCollectionsGenericISet* self, gconstpointer value) {
	g_return_val_if_fail (self != NULL, FALSE);
	return SYSTEM_COLLECTIONS_GENERIC_ISET_GET_INTERFACE (self)->Add (self, value);
}


void system_collections_generic_iset_ExceptWith (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other) {
	g_return_if_fail (self != NULL);
	SYSTEM_COLLECTIONS_GENERIC_ISET_GET_INTERFACE (self)->ExceptWith (self, other);
}


void system_collections_generic_iset_IntersectWith (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other) {
	g_return_if_fail (self != NULL);
	SYSTEM_COLLECTIONS_GENERIC_ISET_GET_INTERFACE (self)->IntersectWith (self, other);
}


gboolean system_collections_generic_iset_IsProperSupersetOf (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other) {
	g_return_val_if_fail (self != NULL, FALSE);
	return SYSTEM_COLLECTIONS_GENERIC_ISET_GET_INTERFACE (self)->IsProperSupersetOf (self, other);
}


gboolean system_collections_generic_iset_IsProperSubsetOf (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other) {
	g_return_val_if_fail (self != NULL, FALSE);
	return SYSTEM_COLLECTIONS_GENERIC_ISET_GET_INTERFACE (self)->IsProperSubsetOf (self, other);
}


gboolean system_collections_generic_iset_IsSubsetOf (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other) {
	g_return_val_if_fail (self != NULL, FALSE);
	return SYSTEM_COLLECTIONS_GENERIC_ISET_GET_INTERFACE (self)->IsSubsetOf (self, other);
}


gboolean system_collections_generic_iset_IsSupersetOf (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other) {
	g_return_val_if_fail (self != NULL, FALSE);
	return SYSTEM_COLLECTIONS_GENERIC_ISET_GET_INTERFACE (self)->IsSupersetOf (self, other);
}


gboolean system_collections_generic_iset_Overlaps (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other) {
	g_return_val_if_fail (self != NULL, FALSE);
	return SYSTEM_COLLECTIONS_GENERIC_ISET_GET_INTERFACE (self)->Overlaps (self, other);
}


gboolean system_collections_generic_iset_SetEquals (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other) {
	g_return_val_if_fail (self != NULL, FALSE);
	return SYSTEM_COLLECTIONS_GENERIC_ISET_GET_INTERFACE (self)->SetEquals (self, other);
}


void system_collections_generic_iset_SymmetricExceptWith (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other) {
	g_return_if_fail (self != NULL);
	SYSTEM_COLLECTIONS_GENERIC_ISET_GET_INTERFACE (self)->SymmetricExceptWith (self, other);
}


void system_collections_generic_iset_UnionWith (SystemCollectionsGenericISet* self, SystemCollectionsGenericIEnumerable* other) {
	g_return_if_fail (self != NULL);
	SYSTEM_COLLECTIONS_GENERIC_ISET_GET_INTERFACE (self)->UnionWith (self, other);
}


static void system_collections_generic_iset_base_init (SystemCollectionsGenericISetIface * iface) {
	static gboolean initialized = FALSE;
	if (!initialized) {
		initialized = TRUE;
		iface->Add = system_collections_generic_iset_real_Add;
	}
}


GType system_collections_generic_iset_get_type (void) {
	static volatile gsize system_collections_generic_iset_type_id__volatile = 0;
	if (g_once_init_enter (&system_collections_generic_iset_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (SystemCollectionsGenericISetIface), (GBaseInitFunc) system_collections_generic_iset_base_init, (GBaseFinalizeFunc) NULL, (GClassInitFunc) NULL, (GClassFinalizeFunc) NULL, NULL, 0, 0, (GInstanceInitFunc) NULL, NULL };
		GType system_collections_generic_iset_type_id;
		system_collections_generic_iset_type_id = g_type_register_static (G_TYPE_INTERFACE, "SystemCollectionsGenericISet", &g_define_type_info, 0);
		g_type_interface_add_prerequisite (system_collections_generic_iset_type_id, GEE_TYPE_SET);
		g_type_interface_add_prerequisite (system_collections_generic_iset_type_id, SYSTEM_COLLECTIONS_GENERIC_TYPE_ICOLLECTION);
		g_once_init_leave (&system_collections_generic_iset_type_id__volatile, system_collections_generic_iset_type_id);
	}
	return system_collections_generic_iset_type_id__volatile;
}



