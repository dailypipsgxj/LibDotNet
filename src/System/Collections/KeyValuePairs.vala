// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

/*============================================================
**
** Class:  KeyValuePairs
**
** Purpose: Defines key/value pairs for displaying items
**          in a collection class under the debugger.
**
===========================================================*/

using System.Diagnostics;

namespace System.Collections
{
	[Compact]
    public class KeyValuePairs
    {
        public GLib.Object _key;
        public GLib.Object _value;

        public KeyValuePairs(GLib.Object key, GLib.Object value)
        {
            _value = value;
            _key = key;
        }
    }
}
