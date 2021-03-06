/* ireadonlylist.c generated by valac 0.29.2.5-8632-dirty, the Vala compiler
 * generated from ireadonlylist.vala, do not modify */

/* ==++==*/
/* */
/*   Copyright (c) Microsoft Corporation.  All rights reserved.*/
/* */
/* ==--==*/
/*============================================================
**
** Interface:  IReadOnlyList<T>
** 
** <OWNER>[....]</OWNER>
**
** Purpose: Base interface for read-only generic lists.
** 
===========================================================*/

#include <glib.h>
#include <glib-object.h>


#define SYSTEM_COLLECTIONS_GENERIC_TYPE_IREAD_ONLY_COLLECTION (system_collections_generic_iread_only_collection_get_type ())
#define SYSTEM_COLLECTIONS_GENERIC_IREAD_ONLY_COLLECTION(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_IREAD_ONLY_COLLECTION, SystemCollectionsGenericIReadOnlyCollection))
#define SYSTEM_COLLECTIONS_GENERIC_IS_IREAD_ONLY_COLLECTION(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_IREAD_ONLY_COLLECTION))
#define SYSTEM_COLLECTIONS_GENERIC_IREAD_ONLY_COLLECTION_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_IREAD_ONLY_COLLECTION, SystemCollectionsGenericIReadOnlyCollectionIface))

typedef struct _SystemCollectionsGenericIReadOnlyCollection SystemCollectionsGenericIReadOnlyCollection;
typedef struct _SystemCollectionsGenericIReadOnlyCollectionIface SystemCollectionsGenericIReadOnlyCollectionIface;

#define SYSTEM_LINQ_TYPE_ENUMERABLE (system_linq_enumerable_get_type ())
#define SYSTEM_LINQ_ENUMERABLE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_LINQ_TYPE_ENUMERABLE, SystemLinqEnumerable))
#define SYSTEM_LINQ_ENUMERABLE_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SYSTEM_LINQ_TYPE_ENUMERABLE, SystemLinqEnumerableClass))
#define SYSTEM_LINQ_IS_ENUMERABLE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_LINQ_TYPE_ENUMERABLE))
#define SYSTEM_LINQ_IS_ENUMERABLE_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SYSTEM_LINQ_TYPE_ENUMERABLE))
#define SYSTEM_LINQ_ENUMERABLE_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SYSTEM_LINQ_TYPE_ENUMERABLE, SystemLinqEnumerableClass))

typedef struct _SystemLinqEnumerable SystemLinqEnumerable;
typedef struct _SystemLinqEnumerableClass SystemLinqEnumerableClass;

#define SYSTEM_COLLECTIONS_GENERIC_TYPE_IENUMERABLE (system_collections_generic_ienumerable_get_type ())
#define SYSTEM_COLLECTIONS_GENERIC_IENUMERABLE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_IENUMERABLE, SystemCollectionsGenericIEnumerable))
#define SYSTEM_COLLECTIONS_GENERIC_IS_IENUMERABLE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_IENUMERABLE))
#define SYSTEM_COLLECTIONS_GENERIC_IENUMERABLE_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_IENUMERABLE, SystemCollectionsGenericIEnumerableIface))

typedef struct _SystemCollectionsGenericIEnumerable SystemCollectionsGenericIEnumerable;
typedef struct _SystemCollectionsGenericIEnumerableIface SystemCollectionsGenericIEnumerableIface;

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

#define SYSTEM_COLLECTIONS_GENERIC_TYPE_ILIST (system_collections_generic_ilist_get_type ())
#define SYSTEM_COLLECTIONS_GENERIC_ILIST(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_ILIST, SystemCollectionsGenericIList))
#define SYSTEM_COLLECTIONS_GENERIC_IS_ILIST(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_ILIST))
#define SYSTEM_COLLECTIONS_GENERIC_ILIST_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_ILIST, SystemCollectionsGenericIListIface))

typedef struct _SystemCollectionsGenericIList SystemCollectionsGenericIList;
typedef struct _SystemCollectionsGenericIListIface SystemCollectionsGenericIListIface;

#define SYSTEM_COLLECTIONS_GENERIC_TYPE_IREAD_ONLY_LIST (system_collections_generic_iread_only_list_get_type ())
#define SYSTEM_COLLECTIONS_GENERIC_IREAD_ONLY_LIST(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_IREAD_ONLY_LIST, SystemCollectionsGenericIReadOnlyList))
#define SYSTEM_COLLECTIONS_GENERIC_IS_IREAD_ONLY_LIST(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_IREAD_ONLY_LIST))
#define SYSTEM_COLLECTIONS_GENERIC_IREAD_ONLY_LIST_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_IREAD_ONLY_LIST, SystemCollectionsGenericIReadOnlyListIface))

typedef struct _SystemCollectionsGenericIReadOnlyList SystemCollectionsGenericIReadOnlyList;
typedef struct _SystemCollectionsGenericIReadOnlyListIface SystemCollectionsGenericIReadOnlyListIface;

struct _SystemCollectionsGenericIReadOnlyCollectionIface {
	GTypeInterface parent_iface;
	gint (*get_size) (SystemCollectionsGenericIReadOnlyCollection* self);
	gint (*get_Count) (SystemCollectionsGenericIReadOnlyCollection* self);
};

struct _SystemCollectionsGenericIEnumeratorIface {
	GTypeInterface parent_iface;
	GType (*get_t_type) (SystemCollectionsGenericIEnumerator* self);
	GBoxedCopyFunc (*get_t_dup_func) (SystemCollectionsGenericIEnumerator* self);
	GDestroyNotify (*get_t_destroy_func) (SystemCollectionsGenericIEnumerator* self);
	gpointer (*get) (SystemCollectionsGenericIEnumerator* self);
	gboolean (*MoveNext) (SystemCollectionsGenericIEnumerator* self);
	gboolean (*next) (SystemCollectionsGenericIEnumerator* self);
	void (*Reset) (SystemCollectionsGenericIEnumerator* self);
	gpointer (*get_Current) (SystemCollectionsGenericIEnumerator* self);
};

struct _SystemCollectionsGenericIEnumerableIface {
	GTypeInterface parent_iface;
	GType (*get_t_type) (SystemCollectionsGenericIEnumerable* self);
	GBoxedCopyFunc (*get_t_dup_func) (SystemCollectionsGenericIEnumerable* self);
	GDestroyNotify (*get_t_destroy_func) (SystemCollectionsGenericIEnumerable* self);
	GType (*get_element_type) (SystemCollectionsGenericIEnumerable* self);
	SystemCollectionsGenericIEnumerator* (*iterator) (SystemCollectionsGenericIEnumerable* self);
	SystemCollectionsGenericIEnumerator* (*GetEnumerator) (SystemCollectionsGenericIEnumerable* self);
};

struct _SystemCollectionsGenericICollectionIface {
	GTypeInterface parent_iface;
	void (*Add) (SystemCollectionsGenericICollection* self, gconstpointer item);
	void (*Clear) (SystemCollectionsGenericICollection* self);
	gboolean (*contains) (SystemCollectionsGenericICollection* self, gconstpointer item);
	gboolean (*Contains) (SystemCollectionsGenericICollection* self, gconstpointer item);
	void (*CopyTo) (SystemCollectionsGenericICollection* self, gpointer* array, int array_length1, gint arrayIndex);
	gboolean (*Remove) (SystemCollectionsGenericICollection* self, gconstpointer item);
	gint (*get_size) (SystemCollectionsGenericICollection* self);
	gint (*get_Count) (SystemCollectionsGenericICollection* self);
	gboolean (*get_IsReadOnly) (SystemCollectionsGenericICollection* self);
};

struct _SystemCollectionsGenericIListIface {
	GTypeInterface parent_iface;
	gpointer (*get) (SystemCollectionsGenericIList* self, gint index);
	void (*set) (SystemCollectionsGenericIList* self, gint index, gconstpointer item);
	gint (*IndexOf) (SystemCollectionsGenericIList* self, gconstpointer item, gint index);
	void (*Insert) (SystemCollectionsGenericIList* self, gint index, gconstpointer item);
	void (*RemoveAt) (SystemCollectionsGenericIList* self, gint index);
};

struct _SystemCollectionsGenericIReadOnlyListIface {
	GTypeInterface parent_iface;
	GType (*get_t_type) (SystemCollectionsGenericIReadOnlyList* self);
	GBoxedCopyFunc (*get_t_dup_func) (SystemCollectionsGenericIReadOnlyList* self);
	GDestroyNotify (*get_t_destroy_func) (SystemCollectionsGenericIReadOnlyList* self);
};



GType system_collections_generic_iread_only_collection_get_type (void) G_GNUC_CONST;
GType system_linq_enumerable_get_type (void) G_GNUC_CONST;
GType system_collections_generic_ienumerator_get_type (void) G_GNUC_CONST;
GType system_collections_generic_ienumerable_get_type (void) G_GNUC_CONST;
GType system_collections_generic_icollection_get_type (void) G_GNUC_CONST;
GType system_collections_generic_ilist_get_type (void) G_GNUC_CONST;
GType system_collections_generic_iread_only_list_get_type (void) G_GNUC_CONST;


static void system_collections_generic_iread_only_list_base_init (SystemCollectionsGenericIReadOnlyListIface * iface) {
#line 32 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ireadonlylist.vala"
	static gboolean initialized = FALSE;
#line 32 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ireadonlylist.vala"
	if (!initialized) {
#line 32 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ireadonlylist.vala"
		initialized = TRUE;
#line 157 "ireadonlylist.c"
	}
}


GType system_collections_generic_iread_only_list_get_type (void) {
	static volatile gsize system_collections_generic_iread_only_list_type_id__volatile = 0;
	if (g_once_init_enter (&system_collections_generic_iread_only_list_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (SystemCollectionsGenericIReadOnlyListIface), (GBaseInitFunc) system_collections_generic_iread_only_list_base_init, (GBaseFinalizeFunc) NULL, (GClassInitFunc) NULL, (GClassFinalizeFunc) NULL, NULL, 0, 0, (GInstanceInitFunc) NULL, NULL };
		GType system_collections_generic_iread_only_list_type_id;
		system_collections_generic_iread_only_list_type_id = g_type_register_static (G_TYPE_INTERFACE, "SystemCollectionsGenericIReadOnlyList", &g_define_type_info, 0);
		g_type_interface_add_prerequisite (system_collections_generic_iread_only_list_type_id, G_TYPE_OBJECT);
		g_type_interface_add_prerequisite (system_collections_generic_iread_only_list_type_id, SYSTEM_COLLECTIONS_GENERIC_TYPE_IREAD_ONLY_COLLECTION);
		g_type_interface_add_prerequisite (system_collections_generic_iread_only_list_type_id, SYSTEM_COLLECTIONS_GENERIC_TYPE_ILIST);
		g_once_init_leave (&system_collections_generic_iread_only_list_type_id__volatile, system_collections_generic_iread_only_list_type_id);
	}
	return system_collections_generic_iread_only_list_type_id__volatile;
}



