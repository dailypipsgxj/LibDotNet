/* istructuralcomparable.c generated by valac 0.26.2, the Vala compiler
 * generated from istructuralcomparable.vala, do not modify */


#include <glib.h>
#include <glib-object.h>


#define SYSTEM_COLLECTIONS_TYPE_ISTRUCTURAL_COMPARABLE (system_collections_istructural_comparable_get_type ())
#define SYSTEM_COLLECTIONS_ISTRUCTURAL_COMPARABLE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_TYPE_ISTRUCTURAL_COMPARABLE, SystemCollectionsIStructuralComparable))
#define SYSTEM_COLLECTIONS_IS_ISTRUCTURAL_COMPARABLE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_TYPE_ISTRUCTURAL_COMPARABLE))
#define SYSTEM_COLLECTIONS_ISTRUCTURAL_COMPARABLE_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_TYPE_ISTRUCTURAL_COMPARABLE, SystemCollectionsIStructuralComparableIface))

typedef struct _SystemCollectionsIStructuralComparable SystemCollectionsIStructuralComparable;
typedef struct _SystemCollectionsIStructuralComparableIface SystemCollectionsIStructuralComparableIface;

#define SYSTEM_COLLECTIONS_TYPE_ICOMPARER (system_collections_icomparer_get_type ())
#define SYSTEM_COLLECTIONS_ICOMPARER(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_COLLECTIONS_TYPE_ICOMPARER, SystemCollectionsIComparer))
#define SYSTEM_COLLECTIONS_IS_ICOMPARER(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_COLLECTIONS_TYPE_ICOMPARER))
#define SYSTEM_COLLECTIONS_ICOMPARER_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), SYSTEM_COLLECTIONS_TYPE_ICOMPARER, SystemCollectionsIComparerIface))

typedef struct _SystemCollectionsIComparer SystemCollectionsIComparer;
typedef struct _SystemCollectionsIComparerIface SystemCollectionsIComparerIface;

struct _SystemCollectionsIComparerIface {
	GTypeInterface parent_iface;
	gint (*Compare) (SystemCollectionsIComparer* self, GObject* x, GObject* y);
};

struct _SystemCollectionsIStructuralComparableIface {
	GTypeInterface parent_iface;
	gint32 (*CompareTo) (SystemCollectionsIStructuralComparable* self, GObject* other, SystemCollectionsIComparer* comparer);
};



GType system_collections_icomparer_get_type (void) G_GNUC_CONST;
GType system_collections_istructural_comparable_get_type (void) G_GNUC_CONST;
gint32 system_collections_istructural_comparable_CompareTo (SystemCollectionsIStructuralComparable* self, GObject* other, SystemCollectionsIComparer* comparer);


gint32 system_collections_istructural_comparable_CompareTo (SystemCollectionsIStructuralComparable* self, GObject* other, SystemCollectionsIComparer* comparer) {
	g_return_val_if_fail (self != NULL, 0);
	return SYSTEM_COLLECTIONS_ISTRUCTURAL_COMPARABLE_GET_INTERFACE (self)->CompareTo (self, other, comparer);
}


static void system_collections_istructural_comparable_base_init (SystemCollectionsIStructuralComparableIface * iface) {
	static gboolean initialized = FALSE;
	if (!initialized) {
		initialized = TRUE;
	}
}


GType system_collections_istructural_comparable_get_type (void) {
	static volatile gsize system_collections_istructural_comparable_type_id__volatile = 0;
	if (g_once_init_enter (&system_collections_istructural_comparable_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (SystemCollectionsIStructuralComparableIface), (GBaseInitFunc) system_collections_istructural_comparable_base_init, (GBaseFinalizeFunc) NULL, (GClassInitFunc) NULL, (GClassFinalizeFunc) NULL, NULL, 0, 0, (GInstanceInitFunc) NULL, NULL };
		GType system_collections_istructural_comparable_type_id;
		system_collections_istructural_comparable_type_id = g_type_register_static (G_TYPE_INTERFACE, "SystemCollectionsIStructuralComparable", &g_define_type_info, 0);
		g_type_interface_add_prerequisite (system_collections_istructural_comparable_type_id, G_TYPE_OBJECT);
		g_once_init_leave (&system_collections_istructural_comparable_type_id__volatile, system_collections_istructural_comparable_type_id);
	}
	return system_collections_istructural_comparable_type_id__volatile;
}



