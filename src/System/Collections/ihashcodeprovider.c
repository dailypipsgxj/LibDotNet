/* ihashcodeprovider.c generated by valac 0.29.2.5-8632-dirty, the Vala compiler
 * generated from ihashcodeprovider.vala, do not modify */

/* ==++==*/
/* */
/*   Copyright (c) Microsoft Corporation.  All rights reserved.*/
/* */
/* ==--==*/
/*============================================================
**
** Interface: IHashCodeProvider
** 
** <OWNER>[....]</OWNER>
**
**
** Purpose: A bunch of strings.
**
** 
===========================================================*/

#include <glib.h>
#include <glib-object.h>


#define SYSTEM_COLLECTIONS_TYPE_IHASH_CODE_PROVIDER (system_collections_ihash_code_provider_get_type ())
#define SYSTEM_COLLECTIONS_IHASH_CODE_PROVIDER(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_TYPE_IHASH_CODE_PROVIDER, SystemCollectionsIHashCodeProvider))
#define SYSTEM_COLLECTIONS_IS_IHASH_CODE_PROVIDER(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_TYPE_IHASH_CODE_PROVIDER))
#define SYSTEM_COLLECTIONS_IHASH_CODE_PROVIDER_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_TYPE_IHASH_CODE_PROVIDER, SystemCollectionsIHashCodeProviderIface))

typedef struct _SystemCollectionsIHashCodeProvider SystemCollectionsIHashCodeProvider;
typedef struct _SystemCollectionsIHashCodeProviderIface SystemCollectionsIHashCodeProviderIface;

struct _SystemCollectionsIHashCodeProviderIface {
	GTypeInterface parent_iface;
	gint (*GetHashCode) (SystemCollectionsIHashCodeProvider* self, GObject* obj);
};



GType system_collections_ihash_code_provider_get_type (void) G_GNUC_CONST;
gint system_collections_ihash_code_provider_GetHashCode (SystemCollectionsIHashCodeProvider* self, GObject* obj);


gint system_collections_ihash_code_provider_GetHashCode (SystemCollectionsIHashCodeProvider* self, GObject* obj) {
#line 28 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/ihashcodeprovider.vala"
	g_return_val_if_fail (self != NULL, 0);
#line 28 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/ihashcodeprovider.vala"
	return SYSTEM_COLLECTIONS_IHASH_CODE_PROVIDER_GET_INTERFACE (self)->GetHashCode (self, obj);
#line 50 "ihashcodeprovider.c"
}


static void system_collections_ihash_code_provider_base_init (SystemCollectionsIHashCodeProviderIface * iface) {
#line 23 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/ihashcodeprovider.vala"
	static gboolean initialized = FALSE;
#line 23 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/ihashcodeprovider.vala"
	if (!initialized) {
#line 23 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/ihashcodeprovider.vala"
		initialized = TRUE;
#line 61 "ihashcodeprovider.c"
	}
}


GType system_collections_ihash_code_provider_get_type (void) {
	static volatile gsize system_collections_ihash_code_provider_type_id__volatile = 0;
	if (g_once_init_enter (&system_collections_ihash_code_provider_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (SystemCollectionsIHashCodeProviderIface), (GBaseInitFunc) system_collections_ihash_code_provider_base_init, (GBaseFinalizeFunc) NULL, (GClassInitFunc) NULL, (GClassFinalizeFunc) NULL, NULL, 0, 0, (GInstanceInitFunc) NULL, NULL };
		GType system_collections_ihash_code_provider_type_id;
		system_collections_ihash_code_provider_type_id = g_type_register_static (G_TYPE_INTERFACE, "SystemCollectionsIHashCodeProvider", &g_define_type_info, 0);
		g_once_init_leave (&system_collections_ihash_code_provider_type_id__volatile, system_collections_ihash_code_provider_type_id);
	}
	return system_collections_ihash_code_provider_type_id__volatile;
}



