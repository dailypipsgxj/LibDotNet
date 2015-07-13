/* idictionary.c generated by valac 0.26.2, the Vala compiler
 * generated from idictionary.vala, do not modify */

/* ==++==
/* 
/*   Copyright (c) Microsoft Corporation.  All rights reserved.
/* 
/* ==--==
/*============================================================
**
** Interface:  IDictionary
** 
** <OWNER>[....]</OWNER>
**
**
** Purpose: Base interface for all dictionaries.
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

#define SYSTEM_COLLECTIONS_TYPE_ICOLLECTION (system_collections_icollection_get_type ())
#define SYSTEM_COLLECTIONS_ICOLLECTION(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_TYPE_ICOLLECTION, SystemCollectionsICollection))
#define SYSTEM_COLLECTIONS_IS_ICOLLECTION(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_TYPE_ICOLLECTION))
#define SYSTEM_COLLECTIONS_ICOLLECTION_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_TYPE_ICOLLECTION, SystemCollectionsICollectionIface))

typedef struct _SystemCollectionsICollection SystemCollectionsICollection;
typedef struct _SystemCollectionsICollectionIface SystemCollectionsICollectionIface;

#define SYSTEM_COLLECTIONS_TYPE_IDICTIONARY (system_collections_idictionary_get_type ())
#define SYSTEM_COLLECTIONS_IDICTIONARY(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_TYPE_IDICTIONARY, SystemCollectionsIDictionary))
#define SYSTEM_COLLECTIONS_IS_IDICTIONARY(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_TYPE_IDICTIONARY))
#define SYSTEM_COLLECTIONS_IDICTIONARY_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_TYPE_IDICTIONARY, SystemCollectionsIDictionaryIface))

typedef struct _SystemCollectionsIDictionary SystemCollectionsIDictionary;
typedef struct _SystemCollectionsIDictionaryIface SystemCollectionsIDictionaryIface;

#define SYSTEM_COLLECTIONS_TYPE_IDICTIONARY_ENUMERATOR (system_collections_idictionary_enumerator_get_type ())
#define SYSTEM_COLLECTIONS_IDICTIONARY_ENUMERATOR(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_TYPE_IDICTIONARY_ENUMERATOR, SystemCollectionsIDictionaryEnumerator))
#define SYSTEM_COLLECTIONS_IS_IDICTIONARY_ENUMERATOR(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_TYPE_IDICTIONARY_ENUMERATOR))
#define SYSTEM_COLLECTIONS_IDICTIONARY_ENUMERATOR_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_TYPE_IDICTIONARY_ENUMERATOR, SystemCollectionsIDictionaryEnumeratorIface))

typedef struct _SystemCollectionsIDictionaryEnumerator SystemCollectionsIDictionaryEnumerator;
typedef struct _SystemCollectionsIDictionaryEnumeratorIface SystemCollectionsIDictionaryEnumeratorIface;

#define SYSTEM_COLLECTIONS_TYPE_DICTIONARY_ENTRY (system_collections_dictionary_entry_get_type ())
#define SYSTEM_COLLECTIONS_DICTIONARY_ENTRY(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_TYPE_DICTIONARY_ENTRY, SystemCollectionsDictionaryEntry))
#define SYSTEM_COLLECTIONS_DICTIONARY_ENTRY_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SYSTEM_COLLECTIONS_TYPE_DICTIONARY_ENTRY, SystemCollectionsDictionaryEntryClass))
#define SYSTEM_COLLECTIONS_IS_DICTIONARY_ENTRY(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_TYPE_DICTIONARY_ENTRY))
#define SYSTEM_COLLECTIONS_IS_DICTIONARY_ENTRY_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SYSTEM_COLLECTIONS_TYPE_DICTIONARY_ENTRY))
#define SYSTEM_COLLECTIONS_DICTIONARY_ENTRY_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SYSTEM_COLLECTIONS_TYPE_DICTIONARY_ENTRY, SystemCollectionsDictionaryEntryClass))

typedef struct _SystemCollectionsDictionaryEntry SystemCollectionsDictionaryEntry;
typedef struct _SystemCollectionsDictionaryEntryClass SystemCollectionsDictionaryEntryClass;

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

struct _SystemCollectionsICollectionIface {
	GTypeInterface parent_iface;
	void (*CopyTo) (SystemCollectionsICollection* self, GArray* array, gint arrayIndex);
	SystemCollectionsIEnumerator* (*iterator) (SystemCollectionsICollection* self);
	gint (*get_Count) (SystemCollectionsICollection* self);
	GObject* (*get_SyncRoot) (SystemCollectionsICollection* self);
	gboolean (*get_IsSynchronized) (SystemCollectionsICollection* self);
};

struct _SystemCollectionsIDictionaryEnumeratorIface {
	GTypeInterface parent_iface;
	GeeMapIterator* (*get__iterator) (SystemCollectionsIDictionaryEnumerator* self);
	void (*set__iterator) (SystemCollectionsIDictionaryEnumerator* self, GeeMapIterator* value);
	GObject* (*get_Key) (SystemCollectionsIDictionaryEnumerator* self);
	GObject* (*get_Value) (SystemCollectionsIDictionaryEnumerator* self);
	SystemCollectionsDictionaryEntry* (*get_Entry) (SystemCollectionsIDictionaryEnumerator* self);
};

struct _SystemCollectionsIDictionaryIface {
	GTypeInterface parent_iface;
	gboolean (*Contains) (SystemCollectionsIDictionary* self, GObject* key);
	void (*Add) (SystemCollectionsIDictionary* self, GObject* key, GObject* value);
	void (*Clear) (SystemCollectionsIDictionary* self);
	SystemCollectionsIDictionaryEnumerator* (*GetEnumerator) (SystemCollectionsIDictionary* self);
	void (*Remove) (SystemCollectionsIDictionary* self, GObject* key);
	SystemCollectionsICollection* (*get_Keys) (SystemCollectionsIDictionary* self);
	SystemCollectionsICollection* (*get_Values) (SystemCollectionsIDictionary* self);
	gboolean (*get_IsReadOnly) (SystemCollectionsIDictionary* self);
	gboolean (*get_IsFixedSize) (SystemCollectionsIDictionary* self);
};



GType system_collections_ienumerator_get_type (void) G_GNUC_CONST;
GType system_collections_ienumerable_get_type (void) G_GNUC_CONST;
GType system_collections_icollection_get_type (void) G_GNUC_CONST;
gpointer system_collections_dictionary_entry_ref (gpointer instance);
void system_collections_dictionary_entry_unref (gpointer instance);
GParamSpec* system_collections_param_spec_dictionary_entry (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void system_collections_value_set_dictionary_entry (GValue* value, gpointer v_object);
void system_collections_value_take_dictionary_entry (GValue* value, gpointer v_object);
gpointer system_collections_value_get_dictionary_entry (const GValue* value);
GType system_collections_dictionary_entry_get_type (void) G_GNUC_CONST;
GType system_collections_idictionary_enumerator_get_type (void) G_GNUC_CONST;
GType system_collections_idictionary_get_type (void) G_GNUC_CONST;
gboolean system_collections_idictionary_Contains (SystemCollectionsIDictionary* self, GObject* key);
static gboolean system_collections_idictionary_real_Contains (SystemCollectionsIDictionary* self, GObject* key);
void system_collections_idictionary_Add (SystemCollectionsIDictionary* self, GObject* key, GObject* value);
static void system_collections_idictionary_real_Add (SystemCollectionsIDictionary* self, GObject* key, GObject* value);
void system_collections_idictionary_Clear (SystemCollectionsIDictionary* self);
static void system_collections_idictionary_real_Clear (SystemCollectionsIDictionary* self);
SystemCollectionsIDictionaryEnumerator* system_collections_idictionary_GetEnumerator (SystemCollectionsIDictionary* self);
void system_collections_idictionary_Remove (SystemCollectionsIDictionary* self, GObject* key);
static void system_collections_idictionary_real_Remove (SystemCollectionsIDictionary* self, GObject* key);
SystemCollectionsICollection* system_collections_idictionary_get_Keys (SystemCollectionsIDictionary* self);
SystemCollectionsICollection* system_collections_idictionary_get_Values (SystemCollectionsIDictionary* self);
static gboolean system_collections_idictionary_get_IsReadOnly (SystemCollectionsIDictionary* self);
static gboolean system_collections_idictionary_get_IsFixedSize (SystemCollectionsIDictionary* self);


static gboolean system_collections_idictionary_real_Contains (SystemCollectionsIDictionary* self, GObject* key) {
	gboolean result = FALSE;
	GObject* _tmp0_ = NULL;
	gboolean _tmp1_ = FALSE;
	g_return_val_if_fail (key != NULL, FALSE);
	_tmp0_ = key;
	_tmp1_ = gee_map_has_key ((GeeMap*) self, _tmp0_);
	result = _tmp1_;
	return result;
}


gboolean system_collections_idictionary_Contains (SystemCollectionsIDictionary* self, GObject* key) {
	g_return_val_if_fail (self != NULL, FALSE);
	return SYSTEM_COLLECTIONS_IDICTIONARY_GET_INTERFACE (self)->Contains (self, key);
}


static void system_collections_idictionary_real_Add (SystemCollectionsIDictionary* self, GObject* key, GObject* value) {
	GObject* _tmp0_ = NULL;
	GObject* _tmp1_ = NULL;
	g_return_if_fail (key != NULL);
	g_return_if_fail (value != NULL);
	_tmp0_ = key;
	_tmp1_ = value;
	gee_map_set ((GeeMap*) self, _tmp0_, _tmp1_);
}


void system_collections_idictionary_Add (SystemCollectionsIDictionary* self, GObject* key, GObject* value) {
	g_return_if_fail (self != NULL);
	SYSTEM_COLLECTIONS_IDICTIONARY_GET_INTERFACE (self)->Add (self, key, value);
}


static void system_collections_idictionary_real_Clear (SystemCollectionsIDictionary* self) {
	gee_map_clear ((GeeMap*) self);
}


void system_collections_idictionary_Clear (SystemCollectionsIDictionary* self) {
	g_return_if_fail (self != NULL);
	SYSTEM_COLLECTIONS_IDICTIONARY_GET_INTERFACE (self)->Clear (self);
}


SystemCollectionsIDictionaryEnumerator* system_collections_idictionary_GetEnumerator (SystemCollectionsIDictionary* self) {
	g_return_val_if_fail (self != NULL, NULL);
	return SYSTEM_COLLECTIONS_IDICTIONARY_GET_INTERFACE (self)->GetEnumerator (self);
}


static void system_collections_idictionary_real_Remove (SystemCollectionsIDictionary* self, GObject* key) {
	GObject* _tmp0_ = NULL;
	g_return_if_fail (key != NULL);
	_tmp0_ = key;
	gee_map_unset ((GeeMap*) self, _tmp0_, NULL);
}


void system_collections_idictionary_Remove (SystemCollectionsIDictionary* self, GObject* key) {
	g_return_if_fail (self != NULL);
	SYSTEM_COLLECTIONS_IDICTIONARY_GET_INTERFACE (self)->Remove (self, key);
}


SystemCollectionsICollection* system_collections_idictionary_get_Keys (SystemCollectionsIDictionary* self) {
	g_return_val_if_fail (self != NULL, NULL);
	return SYSTEM_COLLECTIONS_IDICTIONARY_GET_INTERFACE (self)->get_Keys (self);
}


SystemCollectionsICollection* system_collections_idictionary_get_Values (SystemCollectionsIDictionary* self) {
	g_return_val_if_fail (self != NULL, NULL);
	return SYSTEM_COLLECTIONS_IDICTIONARY_GET_INTERFACE (self)->get_Values (self);
}


static gboolean system_collections_idictionary_get_IsReadOnly (SystemCollectionsIDictionary* self) {
	g_return_val_if_fail (self != NULL, FALSE);
	return SYSTEM_COLLECTIONS_IDICTIONARY_GET_INTERFACE (self)->get_IsReadOnly (self);
}


static gboolean system_collections_idictionary_get_IsFixedSize (SystemCollectionsIDictionary* self) {
	g_return_val_if_fail (self != NULL, FALSE);
	return SYSTEM_COLLECTIONS_IDICTIONARY_GET_INTERFACE (self)->get_IsFixedSize (self);
}


static void system_collections_idictionary_base_init (SystemCollectionsIDictionaryIface * iface) {
	static gboolean initialized = FALSE;
	if (!initialized) {
		initialized = TRUE;
		g_object_interface_install_property (iface, g_param_spec_object ("Keys", "Keys", "Keys", SYSTEM_COLLECTIONS_TYPE_ICOLLECTION, G_PARAM_STATIC_NAME | G_PARAM_STATIC_NICK | G_PARAM_STATIC_BLURB | G_PARAM_READABLE));
		g_object_interface_install_property (iface, g_param_spec_object ("Values", "Values", "Values", SYSTEM_COLLECTIONS_TYPE_ICOLLECTION, G_PARAM_STATIC_NAME | G_PARAM_STATIC_NICK | G_PARAM_STATIC_BLURB | G_PARAM_READABLE));
		iface->Contains = system_collections_idictionary_real_Contains;
		iface->Add = system_collections_idictionary_real_Add;
		iface->Clear = system_collections_idictionary_real_Clear;
		iface->Remove = system_collections_idictionary_real_Remove;
	}
}


GType system_collections_idictionary_get_type (void) {
	static volatile gsize system_collections_idictionary_type_id__volatile = 0;
	if (g_once_init_enter (&system_collections_idictionary_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (SystemCollectionsIDictionaryIface), (GBaseInitFunc) system_collections_idictionary_base_init, (GBaseFinalizeFunc) NULL, (GClassInitFunc) NULL, (GClassFinalizeFunc) NULL, NULL, 0, 0, (GInstanceInitFunc) NULL, NULL };
		GType system_collections_idictionary_type_id;
		system_collections_idictionary_type_id = g_type_register_static (G_TYPE_INTERFACE, "SystemCollectionsIDictionary", &g_define_type_info, 0);
		g_type_interface_add_prerequisite (system_collections_idictionary_type_id, GEE_TYPE_MAP);
		g_type_interface_add_prerequisite (system_collections_idictionary_type_id, SYSTEM_COLLECTIONS_TYPE_ICOLLECTION);
		g_once_init_leave (&system_collections_idictionary_type_id__volatile, system_collections_idictionary_type_id);
	}
	return system_collections_idictionary_type_id__volatile;
}


