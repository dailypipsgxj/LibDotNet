/* icollection.c generated by valac 0.26.2, the Vala compiler
 * generated from icollection.vala, do not modify */

/* ==++==*/
/* */
/*   Copyright (c) Microsoft Corporation.  All rights reserved.*/
/* */
/* ==--==*/
/*============================================================
**
** Interface:  ICollection
** 
** <OWNER>[....]</OWNER>
**
**
** Purpose: Base interface for all generic collections.
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
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))

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
	SystemCollectionsGenericIEnumerator* (*iterator) (SystemCollectionsGenericICollection* self);
	gboolean (*Remove) (SystemCollectionsGenericICollection* self, gconstpointer item);
	gint (*get_Count) (SystemCollectionsGenericICollection* self);
	gboolean (*get_IsReadOnly) (SystemCollectionsGenericICollection* self);
};



GType system_collections_ienumerator_get_type (void) G_GNUC_CONST;
GType system_collections_ienumerable_get_type (void) G_GNUC_CONST;
GType system_idisposable_get_type (void) G_GNUC_CONST;
GType system_collections_generic_ienumerator_get_type (void) G_GNUC_CONST;
GType system_collections_generic_ienumerable_get_type (void) G_GNUC_CONST;
GType system_collections_generic_icollection_get_type (void) G_GNUC_CONST;
void system_collections_generic_icollection_Add (SystemCollectionsGenericICollection* self, gconstpointer item);
static void system_collections_generic_icollection_real_Add (SystemCollectionsGenericICollection* self, gconstpointer item);
void system_collections_generic_icollection_Clear (SystemCollectionsGenericICollection* self);
static void system_collections_generic_icollection_real_Clear (SystemCollectionsGenericICollection* self);
gboolean system_collections_generic_icollection_Contains (SystemCollectionsGenericICollection* self, gconstpointer item);
static gboolean system_collections_generic_icollection_real_Contains (SystemCollectionsGenericICollection* self, gconstpointer item);
void system_collections_generic_icollection_CopyTo (SystemCollectionsGenericICollection* self, gpointer* array, int array_length1, gint arrayIndex);
static void system_collections_generic_icollection_real_CopyTo (SystemCollectionsGenericICollection* self, gpointer* array, int array_length1, gint arrayIndex);
SystemCollectionsGenericIEnumerator* system_collections_generic_icollection_iterator (SystemCollectionsGenericICollection* self);
gboolean system_collections_ienumerator_next (SystemCollectionsIEnumerator* self);
GObject* system_collections_ienumerator_get (SystemCollectionsIEnumerator* self);
static SystemCollectionsGenericIEnumerator* system_collections_generic_icollection_real_iterator (SystemCollectionsGenericICollection* self);
SystemCollectionsGenericIEnumerator* system_collections_generic_ienumerable_GetEnumerator (SystemCollectionsGenericIEnumerable* self);
gboolean system_collections_generic_icollection_Remove (SystemCollectionsGenericICollection* self, gconstpointer item);
static gboolean system_collections_generic_icollection_real_Remove (SystemCollectionsGenericICollection* self, gconstpointer item);
gint system_collections_generic_icollection_get_Count (SystemCollectionsGenericICollection* self);
gboolean system_collections_generic_icollection_get_IsReadOnly (SystemCollectionsGenericICollection* self);


static void system_collections_generic_icollection_real_Add (SystemCollectionsGenericICollection* self, gconstpointer item) {
	gconstpointer _tmp0_ = NULL;
	_tmp0_ = item;
	gee_collection_add ((GeeCollection*) self, _tmp0_);
}


void system_collections_generic_icollection_Add (SystemCollectionsGenericICollection* self, gconstpointer item) {
	g_return_if_fail (self != NULL);
	SYSTEM_COLLECTIONS_GENERIC_ICOLLECTION_GET_INTERFACE (self)->Add (self, item);
}


static void system_collections_generic_icollection_real_Clear (SystemCollectionsGenericICollection* self) {
	gee_collection_clear ((GeeCollection*) self);
}


void system_collections_generic_icollection_Clear (SystemCollectionsGenericICollection* self) {
	g_return_if_fail (self != NULL);
	SYSTEM_COLLECTIONS_GENERIC_ICOLLECTION_GET_INTERFACE (self)->Clear (self);
}


static gboolean system_collections_generic_icollection_real_Contains (SystemCollectionsGenericICollection* self, gconstpointer item) {
	gboolean result = FALSE;
	gconstpointer _tmp0_ = NULL;
	gboolean _tmp1_ = FALSE;
	_tmp0_ = item;
	_tmp1_ = gee_collection_contains ((GeeCollection*) self, _tmp0_);
	result = _tmp1_;
	return result;
}


gboolean system_collections_generic_icollection_Contains (SystemCollectionsGenericICollection* self, gconstpointer item) {
	g_return_val_if_fail (self != NULL, FALSE);
	return SYSTEM_COLLECTIONS_GENERIC_ICOLLECTION_GET_INTERFACE (self)->Contains (self, item);
}


static void system_collections_generic_icollection_real_CopyTo (SystemCollectionsGenericICollection* self, gpointer* array, int array_length1, gint arrayIndex) {
	{
		SystemCollectionsGenericIEnumerator* _item_it = NULL;
		SystemCollectionsGenericIEnumerator* _tmp0_ = NULL;
		_tmp0_ = system_collections_generic_icollection_iterator (self);
		_item_it = _tmp0_;
		while (TRUE) {
			SystemCollectionsGenericIEnumerator* _tmp1_ = NULL;
			gboolean _tmp2_ = FALSE;
			gpointer item = NULL;
			SystemCollectionsGenericIEnumerator* _tmp3_ = NULL;
			GObject* _tmp4_ = NULL;
			gpointer* _tmp5_ = NULL;
			gint _tmp5__length1 = 0;
			gint _tmp6_ = 0;
			gconstpointer _tmp7_ = NULL;
			gpointer _tmp8_ = NULL;
			gpointer _tmp9_ = NULL;
			_tmp1_ = _item_it;
			_tmp2_ = system_collections_ienumerator_next ((SystemCollectionsIEnumerator*) _tmp1_);
			if (!_tmp2_) {
				break;
			}
			_tmp3_ = _item_it;
			_tmp4_ = system_collections_ienumerator_get ((SystemCollectionsIEnumerator*) _tmp3_);
			item = _tmp4_;
			_tmp5_ = array;
			_tmp5__length1 = array_length1;
			_tmp6_ = arrayIndex;
			arrayIndex = _tmp6_ + 1;
			_tmp7_ = item;
			_tmp8_ = ((_tmp7_ != NULL) && (SYSTEM_COLLECTIONS_GENERIC_ICOLLECTION_GET_INTERFACE (self)->get_t_dup_func (self) != NULL)) ? SYSTEM_COLLECTIONS_GENERIC_ICOLLECTION_GET_INTERFACE (self)->get_t_dup_func (self) ((gpointer) _tmp7_) : ((gpointer) _tmp7_);
			((_tmp5_[_tmp6_] == NULL) || (SYSTEM_COLLECTIONS_GENERIC_ICOLLECTION_GET_INTERFACE (self)->get_t_destroy_func (self) == NULL)) ? NULL : (_tmp5_[_tmp6_] = (SYSTEM_COLLECTIONS_GENERIC_ICOLLECTION_GET_INTERFACE (self)->get_t_destroy_func (self) (_tmp5_[_tmp6_]), NULL));
			_tmp5_[_tmp6_] = _tmp8_;
			_tmp9_ = _tmp5_[_tmp6_];
			((item == NULL) || (SYSTEM_COLLECTIONS_GENERIC_ICOLLECTION_GET_INTERFACE (self)->get_t_destroy_func (self) == NULL)) ? NULL : (item = (SYSTEM_COLLECTIONS_GENERIC_ICOLLECTION_GET_INTERFACE (self)->get_t_destroy_func (self) (item), NULL));
		}
		_g_object_unref0 (_item_it);
	}
}


void system_collections_generic_icollection_CopyTo (SystemCollectionsGenericICollection* self, gpointer* array, int array_length1, gint arrayIndex) {
	g_return_if_fail (self != NULL);
	SYSTEM_COLLECTIONS_GENERIC_ICOLLECTION_GET_INTERFACE (self)->CopyTo (self, array, array_length1, arrayIndex);
}


static SystemCollectionsGenericIEnumerator* system_collections_generic_icollection_real_iterator (SystemCollectionsGenericICollection* self) {
	SystemCollectionsGenericIEnumerator* result = NULL;
	SystemCollectionsGenericIEnumerator* _tmp0_ = NULL;
	_tmp0_ = system_collections_generic_ienumerable_GetEnumerator ((SystemCollectionsGenericIEnumerable*) self);
	result = _tmp0_;
	return result;
}


SystemCollectionsGenericIEnumerator* system_collections_generic_icollection_iterator (SystemCollectionsGenericICollection* self) {
	g_return_val_if_fail (self != NULL, NULL);
	return SYSTEM_COLLECTIONS_GENERIC_ICOLLECTION_GET_INTERFACE (self)->iterator (self);
}


static gboolean system_collections_generic_icollection_real_Remove (SystemCollectionsGenericICollection* self, gconstpointer item) {
	gboolean result = FALSE;
	gconstpointer _tmp0_ = NULL;
	gboolean _tmp1_ = FALSE;
	_tmp0_ = item;
	_tmp1_ = gee_collection_remove ((GeeCollection*) self, _tmp0_);
	result = _tmp1_;
	return result;
}


gboolean system_collections_generic_icollection_Remove (SystemCollectionsGenericICollection* self, gconstpointer item) {
	g_return_val_if_fail (self != NULL, FALSE);
	return SYSTEM_COLLECTIONS_GENERIC_ICOLLECTION_GET_INTERFACE (self)->Remove (self, item);
}


gint system_collections_generic_icollection_get_Count (SystemCollectionsGenericICollection* self) {
	g_return_val_if_fail (self != NULL, 0);
	return SYSTEM_COLLECTIONS_GENERIC_ICOLLECTION_GET_INTERFACE (self)->get_Count (self);
}


gboolean system_collections_generic_icollection_get_IsReadOnly (SystemCollectionsGenericICollection* self) {
	g_return_val_if_fail (self != NULL, FALSE);
	return SYSTEM_COLLECTIONS_GENERIC_ICOLLECTION_GET_INTERFACE (self)->get_IsReadOnly (self);
}


static void system_collections_generic_icollection_base_init (SystemCollectionsGenericICollectionIface * iface) {
	static gboolean initialized = FALSE;
	if (!initialized) {
		initialized = TRUE;
		g_object_interface_install_property (iface, g_param_spec_int ("Count", "Count", "Count", G_MININT, G_MAXINT, 0, G_PARAM_STATIC_NAME | G_PARAM_STATIC_NICK | G_PARAM_STATIC_BLURB | G_PARAM_READABLE));
		g_object_interface_install_property (iface, g_param_spec_boolean ("IsReadOnly", "IsReadOnly", "IsReadOnly", FALSE, G_PARAM_STATIC_NAME | G_PARAM_STATIC_NICK | G_PARAM_STATIC_BLURB | G_PARAM_READABLE));
		iface->Add = system_collections_generic_icollection_real_Add;
		iface->Clear = system_collections_generic_icollection_real_Clear;
		iface->Contains = system_collections_generic_icollection_real_Contains;
		iface->CopyTo = system_collections_generic_icollection_real_CopyTo;
		iface->iterator = system_collections_generic_icollection_real_iterator;
		iface->Remove = system_collections_generic_icollection_real_Remove;
	}
}


GType system_collections_generic_icollection_get_type (void) {
	static volatile gsize system_collections_generic_icollection_type_id__volatile = 0;
	if (g_once_init_enter (&system_collections_generic_icollection_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (SystemCollectionsGenericICollectionIface), (GBaseInitFunc) system_collections_generic_icollection_base_init, (GBaseFinalizeFunc) NULL, (GClassInitFunc) NULL, (GClassFinalizeFunc) NULL, NULL, 0, 0, (GInstanceInitFunc) NULL, NULL };
		GType system_collections_generic_icollection_type_id;
		system_collections_generic_icollection_type_id = g_type_register_static (G_TYPE_INTERFACE, "SystemCollectionsGenericICollection", &g_define_type_info, 0);
		g_type_interface_add_prerequisite (system_collections_generic_icollection_type_id, G_TYPE_OBJECT);
		g_type_interface_add_prerequisite (system_collections_generic_icollection_type_id, GEE_TYPE_COLLECTION);
		g_type_interface_add_prerequisite (system_collections_generic_icollection_type_id, SYSTEM_COLLECTIONS_GENERIC_TYPE_IENUMERABLE);
		g_once_init_leave (&system_collections_generic_icollection_type_id__volatile, system_collections_generic_icollection_type_id);
	}
	return system_collections_generic_icollection_type_id__volatile;
}



