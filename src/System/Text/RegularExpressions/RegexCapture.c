/* RegexCapture.c generated by valac 0.26.2, the Vala compiler
 * generated from RegexCapture.vala, do not modify */

/* Copyright (c) Microsoft. All rights reserved.*/
/* Licensed under the MIT license. See LICENSE file in the project root for full license information.*/
/* Capture is just a location/length pair that indicates the*/
/* location of a regular expression match. A single regexp*/
/* search may return multiple Capture within each capturing*/
/* RegexGroup.*/

#include <glib.h>
#include <glib-object.h>
#include <stdlib.h>
#include <string.h>
#include <gobject/gvaluecollector.h>


#define SYSTEM_TEXT_REGULAR_EXPRESSIONS_TYPE_CAPTURE (system_text_regular_expressions_capture_get_type ())
#define SYSTEM_TEXT_REGULAR_EXPRESSIONS_CAPTURE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SYSTEM_TEXT_REGULAR_EXPRESSIONS_TYPE_CAPTURE, SystemTextRegularExpressionsCapture))
#define SYSTEM_TEXT_REGULAR_EXPRESSIONS_CAPTURE_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SYSTEM_TEXT_REGULAR_EXPRESSIONS_TYPE_CAPTURE, SystemTextRegularExpressionsCaptureClass))
#define SYSTEM_TEXT_REGULAR_EXPRESSIONS_IS_CAPTURE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SYSTEM_TEXT_REGULAR_EXPRESSIONS_TYPE_CAPTURE))
#define SYSTEM_TEXT_REGULAR_EXPRESSIONS_IS_CAPTURE_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SYSTEM_TEXT_REGULAR_EXPRESSIONS_TYPE_CAPTURE))
#define SYSTEM_TEXT_REGULAR_EXPRESSIONS_CAPTURE_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SYSTEM_TEXT_REGULAR_EXPRESSIONS_TYPE_CAPTURE, SystemTextRegularExpressionsCaptureClass))

typedef struct _SystemTextRegularExpressionsCapture SystemTextRegularExpressionsCapture;
typedef struct _SystemTextRegularExpressionsCaptureClass SystemTextRegularExpressionsCaptureClass;
typedef struct _SystemTextRegularExpressionsCapturePrivate SystemTextRegularExpressionsCapturePrivate;
#define _g_free0(var) (var = (g_free (var), NULL))
typedef struct _SystemTextRegularExpressionsParamSpecCapture SystemTextRegularExpressionsParamSpecCapture;

struct _SystemTextRegularExpressionsCapture {
	GTypeInstance parent_instance;
	volatile int ref_count;
	SystemTextRegularExpressionsCapturePrivate * priv;
	gchar* _text;
	gint _index;
	gint _length;
};

struct _SystemTextRegularExpressionsCaptureClass {
	GTypeClass parent_class;
	void (*finalize) (SystemTextRegularExpressionsCapture *self);
};

struct _SystemTextRegularExpressionsParamSpecCapture {
	GParamSpec parent_instance;
};


static gpointer system_text_regular_expressions_capture_parent_class = NULL;

gpointer system_text_regular_expressions_capture_ref (gpointer instance);
void system_text_regular_expressions_capture_unref (gpointer instance);
GParamSpec* system_text_regular_expressions_param_spec_capture (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void system_text_regular_expressions_value_set_capture (GValue* value, gpointer v_object);
void system_text_regular_expressions_value_take_capture (GValue* value, gpointer v_object);
gpointer system_text_regular_expressions_value_get_capture (const GValue* value);
GType system_text_regular_expressions_capture_get_type (void) G_GNUC_CONST;
enum  {
	SYSTEM_TEXT_REGULAR_EXPRESSIONS_CAPTURE_DUMMY_PROPERTY
};
SystemTextRegularExpressionsCapture* system_text_regular_expressions_capture_new (const gchar* text, gint i, gint l);
SystemTextRegularExpressionsCapture* system_text_regular_expressions_capture_construct (GType object_type, const gchar* text, gint i, gint l);
gchar* system_text_regular_expressions_capture_ToString (SystemTextRegularExpressionsCapture* self);
gchar* system_text_regular_expressions_capture_get_Value (SystemTextRegularExpressionsCapture* self);
gchar* system_text_regular_expressions_capture_GetOriginalString (SystemTextRegularExpressionsCapture* self);
gchar* system_text_regular_expressions_capture_GetLeftSubString (SystemTextRegularExpressionsCapture* self);
gchar* system_text_regular_expressions_capture_GetRightSubString (SystemTextRegularExpressionsCapture* self);
gint system_text_regular_expressions_capture_get_Index (SystemTextRegularExpressionsCapture* self);
gint system_text_regular_expressions_capture_get_Length (SystemTextRegularExpressionsCapture* self);
static void system_text_regular_expressions_capture_finalize (SystemTextRegularExpressionsCapture* obj);


SystemTextRegularExpressionsCapture* system_text_regular_expressions_capture_construct (GType object_type, const gchar* text, gint i, gint l) {
	SystemTextRegularExpressionsCapture* self = NULL;
	const gchar* _tmp0_ = NULL;
	gchar* _tmp1_ = NULL;
	gint _tmp2_ = 0;
	gint _tmp3_ = 0;
	g_return_val_if_fail (text != NULL, NULL);
	self = (SystemTextRegularExpressionsCapture*) g_type_create_instance (object_type);
	_tmp0_ = text;
	_tmp1_ = g_strdup (_tmp0_);
	_g_free0 (self->_text);
	self->_text = _tmp1_;
	_tmp2_ = i;
	self->_index = _tmp2_;
	_tmp3_ = l;
	self->_length = _tmp3_;
	return self;
}


SystemTextRegularExpressionsCapture* system_text_regular_expressions_capture_new (const gchar* text, gint i, gint l) {
	return system_text_regular_expressions_capture_construct (SYSTEM_TEXT_REGULAR_EXPRESSIONS_TYPE_CAPTURE, text, i, l);
}


gchar* system_text_regular_expressions_capture_ToString (SystemTextRegularExpressionsCapture* self) {
	gchar* result = NULL;
	gchar* _tmp0_ = NULL;
	gchar* _tmp1_ = NULL;
	g_return_val_if_fail (self != NULL, NULL);
	_tmp0_ = system_text_regular_expressions_capture_get_Value (self);
	_tmp1_ = _tmp0_;
	result = _tmp1_;
	return result;
}


gchar* system_text_regular_expressions_capture_GetOriginalString (SystemTextRegularExpressionsCapture* self) {
	gchar* result = NULL;
	const gchar* _tmp0_ = NULL;
	gchar* _tmp1_ = NULL;
	g_return_val_if_fail (self != NULL, NULL);
	_tmp0_ = self->_text;
	_tmp1_ = g_strdup (_tmp0_);
	result = _tmp1_;
	return result;
}


static glong string_strnlen (gchar* str, glong maxlen) {
	glong result = 0L;
	gchar* end = NULL;
	gchar* _tmp0_ = NULL;
	glong _tmp1_ = 0L;
	gchar* _tmp2_ = NULL;
	gchar* _tmp3_ = NULL;
	_tmp0_ = str;
	_tmp1_ = maxlen;
	_tmp2_ = memchr (_tmp0_, 0, (gsize) _tmp1_);
	end = _tmp2_;
	_tmp3_ = end;
	if (_tmp3_ == NULL) {
		glong _tmp4_ = 0L;
		_tmp4_ = maxlen;
		result = _tmp4_;
		return result;
	} else {
		gchar* _tmp5_ = NULL;
		gchar* _tmp6_ = NULL;
		_tmp5_ = end;
		_tmp6_ = str;
		result = (glong) (_tmp5_ - _tmp6_);
		return result;
	}
}


static gchar* string_substring (const gchar* self, glong offset, glong len) {
	gchar* result = NULL;
	glong string_length = 0L;
	gboolean _tmp0_ = FALSE;
	glong _tmp1_ = 0L;
	glong _tmp8_ = 0L;
	glong _tmp14_ = 0L;
	glong _tmp17_ = 0L;
	glong _tmp18_ = 0L;
	glong _tmp19_ = 0L;
	glong _tmp20_ = 0L;
	glong _tmp21_ = 0L;
	gchar* _tmp22_ = NULL;
	g_return_val_if_fail (self != NULL, NULL);
	_tmp1_ = offset;
	if (_tmp1_ >= ((glong) 0)) {
		glong _tmp2_ = 0L;
		_tmp2_ = len;
		_tmp0_ = _tmp2_ >= ((glong) 0);
	} else {
		_tmp0_ = FALSE;
	}
	if (_tmp0_) {
		glong _tmp3_ = 0L;
		glong _tmp4_ = 0L;
		glong _tmp5_ = 0L;
		_tmp3_ = offset;
		_tmp4_ = len;
		_tmp5_ = string_strnlen ((gchar*) self, _tmp3_ + _tmp4_);
		string_length = _tmp5_;
	} else {
		gint _tmp6_ = 0;
		gint _tmp7_ = 0;
		_tmp6_ = strlen (self);
		_tmp7_ = _tmp6_;
		string_length = (glong) _tmp7_;
	}
	_tmp8_ = offset;
	if (_tmp8_ < ((glong) 0)) {
		glong _tmp9_ = 0L;
		glong _tmp10_ = 0L;
		glong _tmp11_ = 0L;
		_tmp9_ = string_length;
		_tmp10_ = offset;
		offset = _tmp9_ + _tmp10_;
		_tmp11_ = offset;
		g_return_val_if_fail (_tmp11_ >= ((glong) 0), NULL);
	} else {
		glong _tmp12_ = 0L;
		glong _tmp13_ = 0L;
		_tmp12_ = offset;
		_tmp13_ = string_length;
		g_return_val_if_fail (_tmp12_ <= _tmp13_, NULL);
	}
	_tmp14_ = len;
	if (_tmp14_ < ((glong) 0)) {
		glong _tmp15_ = 0L;
		glong _tmp16_ = 0L;
		_tmp15_ = string_length;
		_tmp16_ = offset;
		len = _tmp15_ - _tmp16_;
	}
	_tmp17_ = offset;
	_tmp18_ = len;
	_tmp19_ = string_length;
	g_return_val_if_fail ((_tmp17_ + _tmp18_) <= _tmp19_, NULL);
	_tmp20_ = offset;
	_tmp21_ = len;
	_tmp22_ = g_strndup (((gchar*) self) + _tmp20_, (gsize) _tmp21_);
	result = _tmp22_;
	return result;
}


gchar* system_text_regular_expressions_capture_GetLeftSubString (SystemTextRegularExpressionsCapture* self) {
	gchar* result = NULL;
	const gchar* _tmp0_ = NULL;
	gint _tmp1_ = 0;
	gchar* _tmp2_ = NULL;
	g_return_val_if_fail (self != NULL, NULL);
	_tmp0_ = self->_text;
	_tmp1_ = self->_index;
	_tmp2_ = string_substring (_tmp0_, (glong) 0, (glong) _tmp1_);
	result = _tmp2_;
	return result;
}


gchar* system_text_regular_expressions_capture_GetRightSubString (SystemTextRegularExpressionsCapture* self) {
	gchar* result = NULL;
	const gchar* _tmp0_ = NULL;
	gint _tmp1_ = 0;
	gint _tmp2_ = 0;
	const gchar* _tmp3_ = NULL;
	gint _tmp4_ = 0;
	gint _tmp5_ = 0;
	gint _tmp6_ = 0;
	gint _tmp7_ = 0;
	gchar* _tmp8_ = NULL;
	g_return_val_if_fail (self != NULL, NULL);
	_tmp0_ = self->_text;
	_tmp1_ = self->_index;
	_tmp2_ = self->_length;
	_tmp3_ = self->_text;
	_tmp4_ = strlen (_tmp3_);
	_tmp5_ = _tmp4_;
	_tmp6_ = self->_index;
	_tmp7_ = self->_length;
	_tmp8_ = string_substring (_tmp0_, (glong) (_tmp1_ + _tmp2_), (glong) ((_tmp5_ - _tmp6_) - _tmp7_));
	result = _tmp8_;
	return result;
}


gint system_text_regular_expressions_capture_get_Index (SystemTextRegularExpressionsCapture* self) {
	gint result;
	gint _tmp0_ = 0;
	g_return_val_if_fail (self != NULL, 0);
	_tmp0_ = self->_index;
	result = _tmp0_;
	return result;
}


gint system_text_regular_expressions_capture_get_Length (SystemTextRegularExpressionsCapture* self) {
	gint result;
	gint _tmp0_ = 0;
	g_return_val_if_fail (self != NULL, 0);
	_tmp0_ = self->_length;
	result = _tmp0_;
	return result;
}


gchar* system_text_regular_expressions_capture_get_Value (SystemTextRegularExpressionsCapture* self) {
	gchar* result;
	const gchar* _tmp0_ = NULL;
	gint _tmp1_ = 0;
	gint _tmp2_ = 0;
	gchar* _tmp3_ = NULL;
	g_return_val_if_fail (self != NULL, NULL);
	_tmp0_ = self->_text;
	_tmp1_ = self->_index;
	_tmp2_ = self->_length;
	_tmp3_ = string_substring (_tmp0_, (glong) _tmp1_, (glong) _tmp2_);
	result = _tmp3_;
	return result;
}


static void system_text_regular_expressions_value_capture_init (GValue* value) {
	value->data[0].v_pointer = NULL;
}


static void system_text_regular_expressions_value_capture_free_value (GValue* value) {
	if (value->data[0].v_pointer) {
		system_text_regular_expressions_capture_unref (value->data[0].v_pointer);
	}
}


static void system_text_regular_expressions_value_capture_copy_value (const GValue* src_value, GValue* dest_value) {
	if (src_value->data[0].v_pointer) {
		dest_value->data[0].v_pointer = system_text_regular_expressions_capture_ref (src_value->data[0].v_pointer);
	} else {
		dest_value->data[0].v_pointer = NULL;
	}
}


static gpointer system_text_regular_expressions_value_capture_peek_pointer (const GValue* value) {
	return value->data[0].v_pointer;
}


static gchar* system_text_regular_expressions_value_capture_collect_value (GValue* value, guint n_collect_values, GTypeCValue* collect_values, guint collect_flags) {
	if (collect_values[0].v_pointer) {
		SystemTextRegularExpressionsCapture* object;
		object = collect_values[0].v_pointer;
		if (object->parent_instance.g_class == NULL) {
			return g_strconcat ("invalid unclassed object pointer for value type `", G_VALUE_TYPE_NAME (value), "'", NULL);
		} else if (!g_value_type_compatible (G_TYPE_FROM_INSTANCE (object), G_VALUE_TYPE (value))) {
			return g_strconcat ("invalid object type `", g_type_name (G_TYPE_FROM_INSTANCE (object)), "' for value type `", G_VALUE_TYPE_NAME (value), "'", NULL);
		}
		value->data[0].v_pointer = system_text_regular_expressions_capture_ref (object);
	} else {
		value->data[0].v_pointer = NULL;
	}
	return NULL;
}


static gchar* system_text_regular_expressions_value_capture_lcopy_value (const GValue* value, guint n_collect_values, GTypeCValue* collect_values, guint collect_flags) {
	SystemTextRegularExpressionsCapture** object_p;
	object_p = collect_values[0].v_pointer;
	if (!object_p) {
		return g_strdup_printf ("value location for `%s' passed as NULL", G_VALUE_TYPE_NAME (value));
	}
	if (!value->data[0].v_pointer) {
		*object_p = NULL;
	} else if (collect_flags & G_VALUE_NOCOPY_CONTENTS) {
		*object_p = value->data[0].v_pointer;
	} else {
		*object_p = system_text_regular_expressions_capture_ref (value->data[0].v_pointer);
	}
	return NULL;
}


GParamSpec* system_text_regular_expressions_param_spec_capture (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags) {
	SystemTextRegularExpressionsParamSpecCapture* spec;
	g_return_val_if_fail (g_type_is_a (object_type, SYSTEM_TEXT_REGULAR_EXPRESSIONS_TYPE_CAPTURE), NULL);
	spec = g_param_spec_internal (G_TYPE_PARAM_OBJECT, name, nick, blurb, flags);
	G_PARAM_SPEC (spec)->value_type = object_type;
	return G_PARAM_SPEC (spec);
}


gpointer system_text_regular_expressions_value_get_capture (const GValue* value) {
	g_return_val_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, SYSTEM_TEXT_REGULAR_EXPRESSIONS_TYPE_CAPTURE), NULL);
	return value->data[0].v_pointer;
}


void system_text_regular_expressions_value_set_capture (GValue* value, gpointer v_object) {
	SystemTextRegularExpressionsCapture* old;
	g_return_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, SYSTEM_TEXT_REGULAR_EXPRESSIONS_TYPE_CAPTURE));
	old = value->data[0].v_pointer;
	if (v_object) {
		g_return_if_fail (G_TYPE_CHECK_INSTANCE_TYPE (v_object, SYSTEM_TEXT_REGULAR_EXPRESSIONS_TYPE_CAPTURE));
		g_return_if_fail (g_value_type_compatible (G_TYPE_FROM_INSTANCE (v_object), G_VALUE_TYPE (value)));
		value->data[0].v_pointer = v_object;
		system_text_regular_expressions_capture_ref (value->data[0].v_pointer);
	} else {
		value->data[0].v_pointer = NULL;
	}
	if (old) {
		system_text_regular_expressions_capture_unref (old);
	}
}


void system_text_regular_expressions_value_take_capture (GValue* value, gpointer v_object) {
	SystemTextRegularExpressionsCapture* old;
	g_return_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, SYSTEM_TEXT_REGULAR_EXPRESSIONS_TYPE_CAPTURE));
	old = value->data[0].v_pointer;
	if (v_object) {
		g_return_if_fail (G_TYPE_CHECK_INSTANCE_TYPE (v_object, SYSTEM_TEXT_REGULAR_EXPRESSIONS_TYPE_CAPTURE));
		g_return_if_fail (g_value_type_compatible (G_TYPE_FROM_INSTANCE (v_object), G_VALUE_TYPE (value)));
		value->data[0].v_pointer = v_object;
	} else {
		value->data[0].v_pointer = NULL;
	}
	if (old) {
		system_text_regular_expressions_capture_unref (old);
	}
}


static void system_text_regular_expressions_capture_class_init (SystemTextRegularExpressionsCaptureClass * klass) {
	system_text_regular_expressions_capture_parent_class = g_type_class_peek_parent (klass);
	((SystemTextRegularExpressionsCaptureClass *) klass)->finalize = system_text_regular_expressions_capture_finalize;
}


static void system_text_regular_expressions_capture_instance_init (SystemTextRegularExpressionsCapture * self) {
	self->ref_count = 1;
}


static void system_text_regular_expressions_capture_finalize (SystemTextRegularExpressionsCapture* obj) {
	SystemTextRegularExpressionsCapture * self;
	self = G_TYPE_CHECK_INSTANCE_CAST (obj, SYSTEM_TEXT_REGULAR_EXPRESSIONS_TYPE_CAPTURE, SystemTextRegularExpressionsCapture);
	g_signal_handlers_destroy (self);
	_g_free0 (self->_text);
}


GType system_text_regular_expressions_capture_get_type (void) {
	static volatile gsize system_text_regular_expressions_capture_type_id__volatile = 0;
	if (g_once_init_enter (&system_text_regular_expressions_capture_type_id__volatile)) {
		static const GTypeValueTable g_define_type_value_table = { system_text_regular_expressions_value_capture_init, system_text_regular_expressions_value_capture_free_value, system_text_regular_expressions_value_capture_copy_value, system_text_regular_expressions_value_capture_peek_pointer, "p", system_text_regular_expressions_value_capture_collect_value, "p", system_text_regular_expressions_value_capture_lcopy_value };
		static const GTypeInfo g_define_type_info = { sizeof (SystemTextRegularExpressionsCaptureClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) system_text_regular_expressions_capture_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (SystemTextRegularExpressionsCapture), 0, (GInstanceInitFunc) system_text_regular_expressions_capture_instance_init, &g_define_type_value_table };
		static const GTypeFundamentalInfo g_define_type_fundamental_info = { (G_TYPE_FLAG_CLASSED | G_TYPE_FLAG_INSTANTIATABLE | G_TYPE_FLAG_DERIVABLE | G_TYPE_FLAG_DEEP_DERIVABLE) };
		GType system_text_regular_expressions_capture_type_id;
		system_text_regular_expressions_capture_type_id = g_type_register_fundamental (g_type_fundamental_next (), "SystemTextRegularExpressionsCapture", &g_define_type_info, &g_define_type_fundamental_info, 0);
		g_once_init_leave (&system_text_regular_expressions_capture_type_id__volatile, system_text_regular_expressions_capture_type_id);
	}
	return system_text_regular_expressions_capture_type_id__volatile;
}


gpointer system_text_regular_expressions_capture_ref (gpointer instance) {
	SystemTextRegularExpressionsCapture* self;
	self = instance;
	g_atomic_int_inc (&self->ref_count);
	return instance;
}


void system_text_regular_expressions_capture_unref (gpointer instance) {
	SystemTextRegularExpressionsCapture* self;
	self = instance;
	if (g_atomic_int_dec_and_test (&self->ref_count)) {
		SYSTEM_TEXT_REGULAR_EXPRESSIONS_CAPTURE_GET_CLASS (self)->finalize (self);
		g_type_free_instance ((GTypeInstance *) self);
	}
}


