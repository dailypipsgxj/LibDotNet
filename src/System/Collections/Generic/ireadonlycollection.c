/* ireadonlycollection.c generated by valac 0.29.2.5-8632-dirty, the Vala compiler
 * generated from ireadonlycollection.vala, do not modify */

/* ==++==*/
/* */
/*   Copyright (c) Microsoft Corporation.  All rights reserved.*/
/* */
/* ==--==*/
/*============================================================
**
** Interface:  IReadOnlyCollection<T>
** 
** <OWNER>[....]</OWNER>
**
** Purpose: Base interface for read-only generic lists.
** 
===========================================================*/

#include <glib.h>
#include <glib-object.h>


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

#define SYSTEM_COLLECTIONS_GENERIC_TYPE_IREAD_ONLY_COLLECTION (system_collections_generic_iread_only_collection_get_type ())
#define SYSTEM_COLLECTIONS_GENERIC_IREAD_ONLY_COLLECTION(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_IREAD_ONLY_COLLECTION, SystemCollectionsGenericIReadOnlyCollection))
#define SYSTEM_COLLECTIONS_GENERIC_IS_IREAD_ONLY_COLLECTION(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_IREAD_ONLY_COLLECTION))
#define SYSTEM_COLLECTIONS_GENERIC_IREAD_ONLY_COLLECTION_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_IREAD_ONLY_COLLECTION, SystemCollectionsGenericIReadOnlyCollectionIface))

typedef struct _SystemCollectionsGenericIReadOnlyCollection SystemCollectionsGenericIReadOnlyCollection;
typedef struct _SystemCollectionsGenericIReadOnlyCollectionIface SystemCollectionsGenericIReadOnlyCollectionIface;

struct _SystemCollectionsIEnumeratorIface {
	GTypeInterface parent_iface;
	gboolean (*MoveNext) (SystemCollectionsIEnumerator* self);
	void (*Reset) (SystemCollectionsIEnumerator* self);
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
	gpointer (*get_Current) (SystemCollectionsGenericIEnumerator* self);
};

struct _SystemCollectionsGenericIEnumerableIface {
	GTypeInterface parent_iface;
	GType (*get_element_type) (SystemCollectionsGenericIEnumerable* self);
	SystemCollectionsGenericIEnumerator* (*iterator) (SystemCollectionsGenericIEnumerable* self);
	SystemCollectionsGenericIEnumerator* (*GetEnumerator) (SystemCollectionsGenericIEnumerable* self);
};

struct _SystemCollectionsGenericIReadOnlyCollectionIface {
	GTypeInterface parent_iface;
	gint (*get_size) (SystemCollectionsGenericIReadOnlyCollection* self);
	gint (*get_Count) (SystemCollectionsGenericIReadOnlyCollection* self);
};



GType system_collections_ienumerator_get_type (void) G_GNUC_CONST;
GType system_collections_ienumerable_get_type (void) G_GNUC_CONST;
GType system_idisposable_get_type (void) G_GNUC_CONST;
GType system_collections_generic_ienumerator_get_type (void) G_GNUC_CONST;
GType system_collections_generic_ienumerable_get_type (void) G_GNUC_CONST;
GType system_collections_generic_iread_only_collection_get_type (void) G_GNUC_CONST;
gint system_collections_generic_iread_only_collection_get_size (SystemCollectionsGenericIReadOnlyCollection* self);
gint system_collections_generic_iread_only_collection_get_Count (SystemCollectionsGenericIReadOnlyCollection* self);


gint system_collections_generic_iread_only_collection_get_size (SystemCollectionsGenericIReadOnlyCollection* self) {
#line 34 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ireadonlycollection.vala"
	g_return_val_if_fail (self != NULL, 0);
#line 34 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ireadonlycollection.vala"
	return SYSTEM_COLLECTIONS_GENERIC_IREAD_ONLY_COLLECTION_GET_INTERFACE (self)->get_size (self);
#line 124 "ireadonlycollection.c"
}


gint system_collections_generic_iread_only_collection_get_Count (SystemCollectionsGenericIReadOnlyCollection* self) {
#line 35 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ireadonlycollection.vala"
	g_return_val_if_fail (self != NULL, 0);
#line 35 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ireadonlycollection.vala"
	return SYSTEM_COLLECTIONS_GENERIC_IREAD_ONLY_COLLECTION_GET_INTERFACE (self)->get_Count (self);
#line 133 "ireadonlycollection.c"
}


static void system_collections_generic_iread_only_collection_base_init (SystemCollectionsGenericIReadOnlyCollectionIface * iface) {
#line 32 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ireadonlycollection.vala"
	static gboolean initialized = FALSE;
#line 32 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ireadonlycollection.vala"
	if (!initialized) {
#line 32 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ireadonlycollection.vala"
		initialized = TRUE;
#line 144 "ireadonlycollection.c"
	}
}


GType system_collections_generic_iread_only_collection_get_type (void) {
	static volatile gsize system_collections_generic_iread_only_collection_type_id__volatile = 0;
	if (g_once_init_enter (&system_collections_generic_iread_only_collection_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (SystemCollectionsGenericIReadOnlyCollectionIface), (GBaseInitFunc) system_collections_generic_iread_only_collection_base_init, (GBaseFinalizeFunc) NULL, (GClassInitFunc) NULL, (GClassFinalizeFunc) NULL, NULL, 0, 0, (GInstanceInitFunc) NULL, NULL };
		GType system_collections_generic_iread_only_collection_type_id;
		system_collections_generic_iread_only_collection_type_id = g_type_register_static (G_TYPE_INTERFACE, "SystemCollectionsGenericIReadOnlyCollection", &g_define_type_info, 0);
		g_type_interface_add_prerequisite (system_collections_generic_iread_only_collection_type_id, SYSTEM_COLLECTIONS_GENERIC_TYPE_IENUMERABLE);
		g_once_init_leave (&system_collections_generic_iread_only_collection_type_id__volatile, system_collections_generic_iread_only_collection_type_id);
	}
	return system_collections_generic_iread_only_collection_type_id__volatile;
}



