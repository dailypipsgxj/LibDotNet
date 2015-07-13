/* icloneable.c generated by valac 0.26.2, the Vala compiler
 * generated from icloneable.vala, do not modify */

/* ==++==*/
/* */
/*   Copyright (c) Microsoft Corporation.  All rights reserved.*/
/* */
/* ==--==*/
/*============================================================
**
** Class:  ICloneable
**
** This interface is implemented by classes that support cloning.
**
===========================================================*/

#include <glib.h>
#include <glib-object.h>


#define SYSTEM_TYPE_ICLONEABLE (system_icloneable_get_type ())
#define SYSTEM_ICLONEABLE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_TYPE_ICLONEABLE, SystemICloneable))
#define SYSTEM_IS_ICLONEABLE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_TYPE_ICLONEABLE))
#define SYSTEM_ICLONEABLE_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_TYPE_ICLONEABLE, SystemICloneableIface))

typedef struct _SystemICloneable SystemICloneable;
typedef struct _SystemICloneableIface SystemICloneableIface;

struct _SystemICloneableIface {
	GTypeInterface parent_iface;
	GObject* (*Clone) (SystemICloneable* self);
};



GType system_icloneable_get_type (void) G_GNUC_CONST;
GObject* system_icloneable_Clone (SystemICloneable* self);


GObject* system_icloneable_Clone (SystemICloneable* self) {
	g_return_val_if_fail (self != NULL, NULL);
	return SYSTEM_ICLONEABLE_GET_INTERFACE (self)->Clone (self);
}


static void system_icloneable_base_init (SystemICloneableIface * iface) {
	static gboolean initialized = FALSE;
	if (!initialized) {
		initialized = TRUE;
	}
}


GType system_icloneable_get_type (void) {
	static volatile gsize system_icloneable_type_id__volatile = 0;
	if (g_once_init_enter (&system_icloneable_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (SystemICloneableIface), (GBaseInitFunc) system_icloneable_base_init, (GBaseFinalizeFunc) NULL, (GClassInitFunc) NULL, (GClassFinalizeFunc) NULL, NULL, 0, 0, (GInstanceInitFunc) NULL, NULL };
		GType system_icloneable_type_id;
		system_icloneable_type_id = g_type_register_static (G_TYPE_INTERFACE, "SystemICloneable", &g_define_type_info, 0);
		g_once_init_leave (&system_icloneable_type_id__volatile, system_icloneable_type_id);
	}
	return system_icloneable_type_id__volatile;
}



