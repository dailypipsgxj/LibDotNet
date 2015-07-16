/* idisposable.c generated by valac 0.29.2.5-8632-dirty, the Vala compiler
 * generated from idisposable.vala, do not modify */

/* ==++==*/
/* */
/*   Copyright (c) Microsoft Corporation.  All rights reserved.*/
/* */
/* ==--==*/
/*============================================================
**
** Interface:  IDisposable
**
**
** Purpose: Interface for assisting with deterministic finalization.
**
** 
===========================================================*/

#include <glib.h>
#include <glib-object.h>


#define SYSTEM_TYPE_IDISPOSABLE (system_idisposable_get_type ())
#define SYSTEM_IDISPOSABLE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_TYPE_IDISPOSABLE, SystemIDisposable))
#define SYSTEM_IS_IDISPOSABLE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_TYPE_IDISPOSABLE))
#define SYSTEM_IDISPOSABLE_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_TYPE_IDISPOSABLE, SystemIDisposableIface))

typedef struct _SystemIDisposable SystemIDisposable;
typedef struct _SystemIDisposableIface SystemIDisposableIface;

struct _SystemIDisposableIface {
	GTypeInterface parent_iface;
	void (*Dispose) (SystemIDisposable* self);
};



GType system_idisposable_get_type (void) G_GNUC_CONST;
void system_idisposable_Dispose (SystemIDisposable* self);


void system_idisposable_Dispose (SystemIDisposable* self) {
#line 58 "/home/developer/projects/Backup/LibDotNet/src/System/idisposable.vala"
	g_return_if_fail (self != NULL);
#line 58 "/home/developer/projects/Backup/LibDotNet/src/System/idisposable.vala"
	SYSTEM_IDISPOSABLE_GET_INTERFACE (self)->Dispose (self);
#line 48 "idisposable.c"
}


static void system_idisposable_base_init (SystemIDisposableIface * iface) {
#line 57 "/home/developer/projects/Backup/LibDotNet/src/System/idisposable.vala"
	static gboolean initialized = FALSE;
#line 57 "/home/developer/projects/Backup/LibDotNet/src/System/idisposable.vala"
	if (!initialized) {
#line 57 "/home/developer/projects/Backup/LibDotNet/src/System/idisposable.vala"
		initialized = TRUE;
#line 59 "idisposable.c"
	}
}


GType system_idisposable_get_type (void) {
	static volatile gsize system_idisposable_type_id__volatile = 0;
	if (g_once_init_enter (&system_idisposable_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (SystemIDisposableIface), (GBaseInitFunc) system_idisposable_base_init, (GBaseFinalizeFunc) NULL, (GClassInitFunc) NULL, (GClassFinalizeFunc) NULL, NULL, 0, 0, (GInstanceInitFunc) NULL, NULL };
		GType system_idisposable_type_id;
		system_idisposable_type_id = g_type_register_static (G_TYPE_INTERFACE, "SystemIDisposable", &g_define_type_info, 0);
		g_once_init_leave (&system_idisposable_type_id__volatile, system_idisposable_type_id);
	}
	return system_idisposable_type_id__volatile;
}



