/* ilist.c generated by valac 0.29.2.5-8632-dirty, the Vala compiler
 * generated from ilist.vala, do not modify */

/* ==++==*/
/* */
/*   Copyright (c) Microsoft Corporation.  All rights reserved.*/
/* */
/* ==--==*/
/*============================================================
**
** Interface:  IList
** 
** <OWNER>[....]</OWNER>
**
**
** Purpose: Base interface for all generic lists.
**
** 
===========================================================*/

#include <glib.h>
#include <glib-object.h>


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



GType system_linq_enumerable_get_type (void) G_GNUC_CONST;
GType system_collections_generic_ienumerator_get_type (void) G_GNUC_CONST;
GType system_collections_generic_ienumerable_get_type (void) G_GNUC_CONST;
GType system_collections_generic_icollection_get_type (void) G_GNUC_CONST;
GType system_collections_generic_ilist_get_type (void) G_GNUC_CONST;
gpointer system_collections_generic_ilist_get (SystemCollectionsGenericIList* self, gint index);
void system_collections_generic_ilist_set (SystemCollectionsGenericIList* self, gint index, gconstpointer item);
gint system_collections_generic_ilist_IndexOf (SystemCollectionsGenericIList* self, gconstpointer item, gint index);
void system_collections_generic_ilist_Insert (SystemCollectionsGenericIList* self, gint index, gconstpointer item);
void system_collections_generic_ilist_RemoveAt (SystemCollectionsGenericIList* self, gint index);


/**
 * Returns the item at the specified index in this list.
 *
 * @param index zero-based index of the item to be returned
 *
 * @return      the item at the specified index in the list
 */
gpointer system_collections_generic_ilist_get (SystemCollectionsGenericIList* self, gint index) {
#line 45 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ilist.vala"
	g_return_val_if_fail (self != NULL, NULL);
#line 45 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ilist.vala"
	return SYSTEM_COLLECTIONS_GENERIC_ILIST_GET_INTERFACE (self)->get (self, index);
#line 138 "ilist.c"
}


/**
 * Sets the item at the specified index in this list.
 *
 * @param index zero-based index of the item to be set
 */
void system_collections_generic_ilist_set (SystemCollectionsGenericIList* self, gint index, gconstpointer item) {
#line 52 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ilist.vala"
	g_return_if_fail (self != NULL);
#line 52 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ilist.vala"
	SYSTEM_COLLECTIONS_GENERIC_ILIST_GET_INTERFACE (self)->set (self, index, item);
#line 152 "ilist.c"
}


/**
 * Returns the index of the first occurrence of the specified item in
 * this list.
 *
 * @return the index of the first occurrence of the specified item, or
 *         -1 if the item could not be found
 */
gint system_collections_generic_ilist_IndexOf (SystemCollectionsGenericIList* self, gconstpointer item, gint index) {
#line 61 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ilist.vala"
	g_return_val_if_fail (self != NULL, 0);
#line 61 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ilist.vala"
	return SYSTEM_COLLECTIONS_GENERIC_ILIST_GET_INTERFACE (self)->IndexOf (self, item, index);
#line 168 "ilist.c"
}


/**
 * Inserts an item into this list at the specified position.
 *
 * @param index zero-based index at which item is inserted
 * @param item  item to insert into the list
 */
void system_collections_generic_ilist_Insert (SystemCollectionsGenericIList* self, gint index, gconstpointer item) {
#line 69 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ilist.vala"
	g_return_if_fail (self != NULL);
#line 69 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ilist.vala"
	SYSTEM_COLLECTIONS_GENERIC_ILIST_GET_INTERFACE (self)->Insert (self, index, item);
#line 183 "ilist.c"
}


/**
 * Removes the item at the specified index of this list.
 *
 * @param index zero-based index of the item to be removed
 */
void system_collections_generic_ilist_RemoveAt (SystemCollectionsGenericIList* self, gint index) {
#line 76 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ilist.vala"
	g_return_if_fail (self != NULL);
#line 76 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ilist.vala"
	SYSTEM_COLLECTIONS_GENERIC_ILIST_GET_INTERFACE (self)->RemoveAt (self, index);
#line 197 "ilist.c"
}


static void system_collections_generic_ilist_base_init (SystemCollectionsGenericIListIface * iface) {
#line 35 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ilist.vala"
	static gboolean initialized = FALSE;
#line 35 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ilist.vala"
	if (!initialized) {
#line 35 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/ilist.vala"
		initialized = TRUE;
#line 208 "ilist.c"
	}
}


GType system_collections_generic_ilist_get_type (void) {
	static volatile gsize system_collections_generic_ilist_type_id__volatile = 0;
	if (g_once_init_enter (&system_collections_generic_ilist_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (SystemCollectionsGenericIListIface), (GBaseInitFunc) system_collections_generic_ilist_base_init, (GBaseFinalizeFunc) NULL, (GClassInitFunc) NULL, (GClassFinalizeFunc) NULL, NULL, 0, 0, (GInstanceInitFunc) NULL, NULL };
		GType system_collections_generic_ilist_type_id;
		system_collections_generic_ilist_type_id = g_type_register_static (G_TYPE_INTERFACE, "SystemCollectionsGenericIList", &g_define_type_info, 0);
		g_type_interface_add_prerequisite (system_collections_generic_ilist_type_id, SYSTEM_COLLECTIONS_GENERIC_TYPE_ICOLLECTION);
		g_once_init_leave (&system_collections_generic_ilist_type_id__volatile, system_collections_generic_ilist_type_id);
	}
	return system_collections_generic_ilist_type_id__volatile;
}



