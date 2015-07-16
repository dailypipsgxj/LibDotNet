/* icomparer.c generated by valac 0.29.2.5-8632-dirty, the Vala compiler
 * generated from icomparer.vala, do not modify */

/* ==++==*/
/* */
/*   Copyright (c) Microsoft Corporation.  All rights reserved.*/
/* */
/* ==--==*/
/*============================================================
**
** Interface:  IComparer
** 
** <OWNER>[....]</OWNER>
**
**
** Purpose: Interface for comparing two generic Objects.
**
** 
===========================================================*/

#include <glib.h>
#include <glib-object.h>


#define SYSTEM_COLLECTIONS_GENERIC_TYPE_ICOMPARER (system_collections_generic_icomparer_get_type ())
#define SYSTEM_COLLECTIONS_GENERIC_ICOMPARER(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_ICOMPARER, SystemCollectionsGenericIComparer))
#define SYSTEM_COLLECTIONS_GENERIC_IS_ICOMPARER(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_ICOMPARER))
#define SYSTEM_COLLECTIONS_GENERIC_ICOMPARER_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_GENERIC_TYPE_ICOMPARER, SystemCollectionsGenericIComparerIface))

typedef struct _SystemCollectionsGenericIComparer SystemCollectionsGenericIComparer;
typedef struct _SystemCollectionsGenericIComparerIface SystemCollectionsGenericIComparerIface;

struct _SystemCollectionsGenericIComparerIface {
	GTypeInterface parent_iface;
	gint (*Compare) (SystemCollectionsGenericIComparer* self, gconstpointer x, gconstpointer y);
};



GType system_collections_generic_icomparer_get_type (void) G_GNUC_CONST;
gint system_collections_generic_icomparer_Compare (SystemCollectionsGenericIComparer* self, gconstpointer x, gconstpointer y);


gint system_collections_generic_icomparer_Compare (SystemCollectionsGenericIComparer* self, gconstpointer x, gconstpointer y) {
#line 29 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/icomparer.vala"
	g_return_val_if_fail (self != NULL, 0);
#line 29 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/icomparer.vala"
	return SYSTEM_COLLECTIONS_GENERIC_ICOMPARER_GET_INTERFACE (self)->Compare (self, x, y);
#line 50 "icomparer.c"
}


static void system_collections_generic_icomparer_base_init (SystemCollectionsGenericIComparerIface * iface) {
#line 23 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/icomparer.vala"
	static gboolean initialized = FALSE;
#line 23 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/icomparer.vala"
	if (!initialized) {
#line 23 "/home/developer/projects/Backup/LibDotNet/src/System/Collections/Generic/icomparer.vala"
		initialized = TRUE;
#line 61 "icomparer.c"
	}
}


GType system_collections_generic_icomparer_get_type (void) {
	static volatile gsize system_collections_generic_icomparer_type_id__volatile = 0;
	if (g_once_init_enter (&system_collections_generic_icomparer_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (SystemCollectionsGenericIComparerIface), (GBaseInitFunc) system_collections_generic_icomparer_base_init, (GBaseFinalizeFunc) NULL, (GClassInitFunc) NULL, (GClassFinalizeFunc) NULL, NULL, 0, 0, (GInstanceInitFunc) NULL, NULL };
		GType system_collections_generic_icomparer_type_id;
		system_collections_generic_icomparer_type_id = g_type_register_static (G_TYPE_INTERFACE, "SystemCollectionsGenericIComparer", &g_define_type_info, 0);
		g_once_init_leave (&system_collections_generic_icomparer_type_id__volatile, system_collections_generic_icomparer_type_id);
	}
	return system_collections_generic_icomparer_type_id__volatile;
}



