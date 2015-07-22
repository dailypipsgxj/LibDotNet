/* idictionaryenumerator.c generated by valac 0.29.2.5-8632-dirty, the Vala compiler
 * generated from idictionaryenumerator.vala, do not modify */

/* ==++==
/* 
/*   Copyright (c) Microsoft Corporation.  All rights reserved.
/* 
/* ==--==
/*============================================================
**
** Interface:  IDictionaryEnumerator
** 
** <OWNER>[....]</OWNER>
**
**
** Purpose: Base interface for dictionary enumerators.
**
** 
===========================================================*/

#include <glib.h>
#include <glib-object.h>


#define SYSTEM_COLLECTIONS_GENERIC_TYPE_IDICTIONARY_ENUMERATOR (system_collections_generic_idictionary_enumerator_get_type ())
#define SYSTEM_COLLECTIONS_GENERIC_IDICTIONARY_ENUMERATOR(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_IDICTIONARY_ENUMERATOR, SystemCollectionsGenericIDictionaryEnumerator))
#define SYSTEM_COLLECTIONS_GENERIC_IS_IDICTIONARY_ENUMERATOR(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_IDICTIONARY_ENUMERATOR))
#define SYSTEM_COLLECTIONS_GENERIC_IDICTIONARY_ENUMERATOR_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_IDICTIONARY_ENUMERATOR, SystemCollectionsGenericIDictionaryEnumeratorIface))

typedef struct _SystemCollectionsGenericIDictionaryEnumerator SystemCollectionsGenericIDictionaryEnumerator;
typedef struct _SystemCollectionsGenericIDictionaryEnumeratorIface SystemCollectionsGenericIDictionaryEnumeratorIface;

#define SYSTEM_COLLECTIONS_GENERIC_TYPE_DICTIONARY_ENTRY (system_collections_generic_dictionary_entry_get_type ())
#define SYSTEM_COLLECTIONS_GENERIC_DICTIONARY_ENTRY(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_DICTIONARY_ENTRY, SystemCollectionsGenericDictionaryEntry))
#define SYSTEM_COLLECTIONS_GENERIC_DICTIONARY_ENTRY_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SYSTEM_COLLECTIONS_GENERIC_TYPE_DICTIONARY_ENTRY, SystemCollectionsGenericDictionaryEntryClass))
#define SYSTEM_COLLECTIONS_GENERIC_IS_DICTIONARY_ENTRY(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_DICTIONARY_ENTRY))
#define SYSTEM_COLLECTIONS_GENERIC_IS_DICTIONARY_ENTRY_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SYSTEM_COLLECTIONS_GENERIC_TYPE_DICTIONARY_ENTRY))
#define SYSTEM_COLLECTIONS_GENERIC_DICTIONARY_ENTRY_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_DICTIONARY_ENTRY, SystemCollectionsGenericDictionaryEntryClass))

typedef struct _SystemCollectionsGenericDictionaryEntry SystemCollectionsGenericDictionaryEntry;
typedef struct _SystemCollectionsGenericDictionaryEntryClass SystemCollectionsGenericDictionaryEntryClass;

#define SYSTEM_COLLECTIONS_GENERIC_TYPE_KEY_VALUE_PAIR (system_collections_generic_key_value_pair_get_type ())
#define SYSTEM_COLLECTIONS_GENERIC_KEY_VALUE_PAIR(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_KEY_VALUE_PAIR, SystemCollectionsGenericKeyValuePair))
#define SYSTEM_COLLECTIONS_GENERIC_KEY_VALUE_PAIR_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SYSTEM_COLLECTIONS_GENERIC_TYPE_KEY_VALUE_PAIR, SystemCollectionsGenericKeyValuePairClass))
#define SYSTEM_COLLECTIONS_GENERIC_IS_KEY_VALUE_PAIR(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_KEY_VALUE_PAIR))
#define SYSTEM_COLLECTIONS_GENERIC_IS_KEY_VALUE_PAIR_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SYSTEM_COLLECTIONS_GENERIC_TYPE_KEY_VALUE_PAIR))
#define SYSTEM_COLLECTIONS_GENERIC_KEY_VALUE_PAIR_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_KEY_VALUE_PAIR, SystemCollectionsGenericKeyValuePairClass))

typedef struct _SystemCollectionsGenericKeyValuePair SystemCollectionsGenericKeyValuePair;
typedef struct _SystemCollectionsGenericKeyValuePairClass SystemCollectionsGenericKeyValuePairClass;

struct _SystemCollectionsGenericIDictionaryEnumeratorIface {
	GTypeInterface parent_iface;
	gpointer (*get_Key) (SystemCollectionsGenericIDictionaryEnumerator* self);
	gpointer (*get_Value) (SystemCollectionsGenericIDictionaryEnumerator* self);
	SystemCollectionsGenericDictionaryEntry* (*get_Entry) (SystemCollectionsGenericIDictionaryEnumerator* self);
	SystemCollectionsGenericKeyValuePair* (*get_Current) (SystemCollectionsGenericIDictionaryEnumerator* self);
};



gpointer system_collections_generic_dictionary_entry_ref (gpointer instance);
void system_collections_generic_dictionary_entry_unref (gpointer instance);
GParamSpec* system_collections_generic_param_spec_dictionary_entry (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void system_collections_generic_value_set_dictionary_entry (GValue* value, gpointer v_object);
void system_collections_generic_value_take_dictionary_entry (GValue* value, gpointer v_object);
gpointer system_collections_generic_value_get_dictionary_entry (const GValue* value);
GType system_collections_generic_dictionary_entry_get_type (void) G_GNUC_CONST;
gpointer system_collections_generic_key_value_pair_ref (gpointer instance);
void system_collections_generic_key_value_pair_unref (gpointer instance);
GParamSpec* system_collections_generic_param_spec_key_value_pair (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void system_collections_generic_value_set_key_value_pair (GValue* value, gpointer v_object);
void system_collections_generic_value_take_key_value_pair (GValue* value, gpointer v_object);
gpointer system_collections_generic_value_get_key_value_pair (const GValue* value);
GType system_collections_generic_key_value_pair_get_type (void) G_GNUC_CONST;
GType system_collections_generic_idictionary_enumerator_get_type (void) G_GNUC_CONST;
gpointer system_collections_generic_idictionary_enumerator_get_Key (SystemCollectionsGenericIDictionaryEnumerator* self);
gpointer system_collections_generic_idictionary_enumerator_get_Value (SystemCollectionsGenericIDictionaryEnumerator* self);
SystemCollectionsGenericDictionaryEntry* system_collections_generic_idictionary_enumerator_get_Entry (SystemCollectionsGenericIDictionaryEnumerator* self);
SystemCollectionsGenericKeyValuePair* system_collections_generic_idictionary_enumerator_get_Current (SystemCollectionsGenericIDictionaryEnumerator* self);


gpointer system_collections_generic_idictionary_enumerator_get_Key (SystemCollectionsGenericIDictionaryEnumerator* self) {
#line 57 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/idictionaryenumerator.vala"
	g_return_val_if_fail (self != NULL, NULL);
#line 57 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/idictionaryenumerator.vala"
	return SYSTEM_COLLECTIONS_GENERIC_IDICTIONARY_ENUMERATOR_GET_INTERFACE (self)->get_Key (self);
#line 90 "idictionaryenumerator.c"
}


gpointer system_collections_generic_idictionary_enumerator_get_Value (SystemCollectionsGenericIDictionaryEnumerator* self) {
#line 65 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/idictionaryenumerator.vala"
	g_return_val_if_fail (self != NULL, NULL);
#line 65 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/idictionaryenumerator.vala"
	return SYSTEM_COLLECTIONS_GENERIC_IDICTIONARY_ENUMERATOR_GET_INTERFACE (self)->get_Value (self);
#line 99 "idictionaryenumerator.c"
}


SystemCollectionsGenericDictionaryEntry* system_collections_generic_idictionary_enumerator_get_Entry (SystemCollectionsGenericIDictionaryEnumerator* self) {
#line 67 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/idictionaryenumerator.vala"
	g_return_val_if_fail (self != NULL, NULL);
#line 67 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/idictionaryenumerator.vala"
	return SYSTEM_COLLECTIONS_GENERIC_IDICTIONARY_ENUMERATOR_GET_INTERFACE (self)->get_Entry (self);
#line 108 "idictionaryenumerator.c"
}


SystemCollectionsGenericKeyValuePair* system_collections_generic_idictionary_enumerator_get_Current (SystemCollectionsGenericIDictionaryEnumerator* self) {
#line 69 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/idictionaryenumerator.vala"
	g_return_val_if_fail (self != NULL, NULL);
#line 69 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/idictionaryenumerator.vala"
	return SYSTEM_COLLECTIONS_GENERIC_IDICTIONARY_ENUMERATOR_GET_INTERFACE (self)->get_Current (self);
#line 117 "idictionaryenumerator.c"
}


static void system_collections_generic_idictionary_enumerator_base_init (SystemCollectionsGenericIDictionaryEnumeratorIface * iface) {
#line 49 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/idictionaryenumerator.vala"
	static gboolean initialized = FALSE;
#line 49 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/idictionaryenumerator.vala"
	if (!initialized) {
#line 49 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/idictionaryenumerator.vala"
		initialized = TRUE;
#line 128 "idictionaryenumerator.c"
	}
}


GType system_collections_generic_idictionary_enumerator_get_type (void) {
	static volatile gsize system_collections_generic_idictionary_enumerator_type_id__volatile = 0;
	if (g_once_init_enter (&system_collections_generic_idictionary_enumerator_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (SystemCollectionsGenericIDictionaryEnumeratorIface), (GBaseInitFunc) system_collections_generic_idictionary_enumerator_base_init, (GBaseFinalizeFunc) NULL, (GClassInitFunc) NULL, (GClassFinalizeFunc) NULL, NULL, 0, 0, (GInstanceInitFunc) NULL, NULL };
		GType system_collections_generic_idictionary_enumerator_type_id;
		system_collections_generic_idictionary_enumerator_type_id = g_type_register_static (G_TYPE_INTERFACE, "SystemCollectionsGenericIDictionaryEnumerator", &g_define_type_info, 0);
		g_once_init_leave (&system_collections_generic_idictionary_enumerator_type_id__volatile, system_collections_generic_idictionary_enumerator_type_id);
	}
	return system_collections_generic_idictionary_enumerator_type_id__volatile;
}


