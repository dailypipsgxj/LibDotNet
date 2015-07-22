/* String.c generated by valac 0.29.2.5-8632-dirty, the Vala compiler
 * generated from String.vala, do not modify */


#include <glib.h>
#include <glib-object.h>
#include <stdlib.h>
#include <string.h>

typedef struct _SystemString SystemString;

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
#define _g_free0(var) (var = (g_free (var), NULL))
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))

struct _SystemString {
	int dummy;
};

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



void system_string_free (SystemString* self);
static void system_string_instance_init (SystemString * self);
GType system_linq_enumerable_get_type (void) G_GNUC_CONST;
GType system_collections_generic_ienumerator_get_type (void) G_GNUC_CONST;
GType system_collections_generic_ienumerable_get_type (void) G_GNUC_CONST;
gchar* system_string_Join (const gchar* separator, SystemCollectionsGenericIEnumerable* enumerable);
SystemCollectionsGenericIEnumerator* system_collections_generic_ienumerable_GetEnumerator (SystemCollectionsGenericIEnumerable* self);
gboolean system_collections_generic_ienumerator_MoveNext (SystemCollectionsGenericIEnumerator* self);
gpointer system_collections_generic_ienumerator_get_Current (SystemCollectionsGenericIEnumerator* self);
const SystemString* system_string_new (void);
const SystemString* system_string_new (void);


gchar* system_string_Join (const gchar* separator, SystemCollectionsGenericIEnumerable* enumerable) {
	gchar* result = NULL;
	gchar* _result_ = NULL;
	gchar* _tmp0_ = NULL;
	SystemCollectionsGenericIEnumerator* enumerator = NULL;
	SystemCollectionsGenericIEnumerable* _tmp1_ = NULL;
	SystemCollectionsGenericIEnumerator* _tmp2_ = NULL;
	SystemCollectionsGenericIEnumerator* _tmp3_ = NULL;
	gboolean _tmp4_ = FALSE;
#line 9 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
	g_return_val_if_fail (separator != NULL, NULL);
#line 9 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
	g_return_val_if_fail (enumerable != NULL, NULL);
#line 11 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
	_tmp0_ = g_strdup ("");
#line 11 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
	_result_ = _tmp0_;
#line 12 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
	_tmp1_ = enumerable;
#line 12 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
	_tmp2_ = system_collections_generic_ienumerable_GetEnumerator (_tmp1_);
#line 12 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
	enumerator = _tmp2_;
#line 14 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
	_tmp3_ = enumerator;
#line 14 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
	_tmp4_ = system_collections_generic_ienumerator_MoveNext (_tmp3_);
#line 14 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
	if (_tmp4_) {
#line 111 "String.c"
		SystemCollectionsGenericIEnumerator* _tmp5_ = NULL;
		gpointer _tmp6_ = NULL;
		gchar* _tmp7_ = NULL;
#line 15 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
		_tmp5_ = enumerator;
#line 15 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
		_tmp6_ = system_collections_generic_ienumerator_get_Current (_tmp5_);
#line 15 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
		_tmp7_ = _tmp6_;
#line 15 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
		_g_free0 (_result_);
#line 15 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
		_result_ = (gchar*) _tmp7_;
#line 125 "String.c"
	}
#line 18 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
	while (TRUE) {
#line 129 "String.c"
		SystemCollectionsGenericIEnumerator* _tmp8_ = NULL;
		gboolean _tmp9_ = FALSE;
		const gchar* _tmp10_ = NULL;
		const gchar* _tmp11_ = NULL;
		SystemCollectionsGenericIEnumerator* _tmp12_ = NULL;
		gpointer _tmp13_ = NULL;
		gchar* _tmp14_ = NULL;
		gchar* _tmp15_ = NULL;
		gchar* _tmp16_ = NULL;
		gchar* _tmp17_ = NULL;
		gchar* _tmp18_ = NULL;
#line 18 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
		_tmp8_ = enumerator;
#line 18 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
		_tmp9_ = system_collections_generic_ienumerator_MoveNext (_tmp8_);
#line 18 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
		if (!_tmp9_) {
#line 18 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
			break;
#line 149 "String.c"
		}
#line 19 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
		_tmp10_ = _result_;
#line 19 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
		_tmp11_ = separator;
#line 19 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
		_tmp12_ = enumerator;
#line 19 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
		_tmp13_ = system_collections_generic_ienumerator_get_Current (_tmp12_);
#line 19 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
		_tmp14_ = _tmp13_;
#line 19 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
		_tmp15_ = (gchar*) _tmp14_;
#line 19 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
		_tmp16_ = g_strconcat (_tmp11_, _tmp15_, NULL);
#line 19 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
		_tmp17_ = _tmp16_;
#line 19 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
		_tmp18_ = g_strconcat (_tmp10_, _tmp17_, NULL);
#line 19 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
		_g_free0 (_result_);
#line 19 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
		_result_ = _tmp18_;
#line 19 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
		_g_free0 (_tmp17_);
#line 19 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
		_g_free0 (_tmp15_);
#line 177 "String.c"
	}
#line 22 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
	result = _result_;
#line 22 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
	_g_object_unref0 (enumerator);
#line 22 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
	return result;
#line 185 "String.c"
}


const SystemString* system_string_new (void) {
	SystemString* self;
#line 7 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
	self = g_slice_new0 (SystemString);
#line 7 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
	system_string_instance_init (self);
#line 7 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
	return self;
#line 197 "String.c"
}


static void system_string_instance_init (SystemString * self) {
}


void system_string_free (SystemString* self) {
#line 7 "/home/developer/projects/Backup/LibDotNet/src/System/String.vala"
	g_slice_free (SystemString, self);
#line 208 "String.c"
}


