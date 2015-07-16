// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
/*============================================================
**
** Interface:  DictionaryEntry
** 
** <OWNER>[....]</OWNER>
**
**
** Purpose: Return Value for IDictionaryEnumerator::GetEntry
**
** 
===========================================================*/
namespace System.Collections {
    
    using System;
    // A DictionaryEntry holds a key and a value from a dictionary.
    // It is returned by IDictionaryEnumerator::GetEntry().

	//[Compact]
    public class DictionaryEntry
    {
        private GLib.Object _key;
        private GLib.Object _value;
    
        // Constructs a new DictionaryEnumerator by setting the Key
        // and Value fields appropriately.
        public DictionaryEntry(GLib.Object key, GLib.Object value) {
            _key = key;
            _value = value;
        }

        public GLib.Object Key {
            get {
                return _key;
            }
            
            set {
                _key = value;
            }
        }

        public GLib.Object Value {
            get {
                return _value;
            }

            set {
                _value = value;
            }
        }
    }
}
