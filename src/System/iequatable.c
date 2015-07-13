/* iequatable.c generated by valac 0.26.2, the Vala compiler
 * generated from iequatable.vala, do not modify */

/* ==++==*/
/* */
/*   Copyright (c) Microsoft Corporation.  All rights reserved.*/
/* */
/* ==--==*/

#include <glib.h>
#include <glib-object.h>


#define SYSTEM_TYPE_IEQUATABLE (system_iequatable_get_type ())
#define SYSTEM_IEQUATABLE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_TYPE_IEQUATABLE, SystemIEquatable))
#define SYSTEM_IS_IEQUATABLE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_TYPE_IEQUATABLE))
#define SYSTEM_IEQUATABLE_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_TYPE_IEQUATABLE, SystemIEquatableIface))

typedef struct _SystemIEquatable SystemIEquatable;
typedef struct _SystemIEquatableIface SystemIEquatableIface;

struct _SystemIEquatableIface {
	GTypeInterface parent_iface;
	gboolean (*Equals) (SystemIEquatable* self, gconstpointer other);
};



GType system_iequatable_get_type (void) G_GNUC_CONST;
gboolean system_iequatable_Equals (SystemIEquatable* self, gconstpointer other);


gboolean system_iequatable_Equals (SystemIEquatable* self, gconstpointer other) {
	g_return_val_if_fail (self != NULL, FALSE);
	return SYSTEM_IEQUATABLE_GET_INTERFACE (self)->Equals (self, other);
}


static void system_iequatable_base_init (SystemIEquatableIface * iface) {
	static gboolean initialized = FALSE;
	if (!initialized) {
		initialized = TRUE;
	}
}


GType system_iequatable_get_type (void) {
	static volatile gsize system_iequatable_type_id__volatile = 0;
	if (g_once_init_enter (&system_iequatable_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (SystemIEquatableIface), (GBaseInitFunc) system_iequatable_base_init, (GBaseFinalizeFunc) NULL, (GClassInitFunc) NULL, (GClassFinalizeFunc) NULL, NULL, 0, 0, (GInstanceInitFunc) NULL, NULL };
		GType system_iequatable_type_id;
		system_iequatable_type_id = g_type_register_static (G_TYPE_INTERFACE, "SystemIEquatable", &g_define_type_info, 0);
		g_once_init_leave (&system_iequatable_type_id__volatile, system_iequatable_type_id);
	}
	return system_iequatable_type_id__volatile;
}



