// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
/*============================================================
**
** Interface:  DictionaryEntry
**
** Purpose: Return Value for IDictionaryEnumerator::GetEntry
**
** 
===========================================================*/
namespace System.Collections.Generic {
    
    using System;
    // A DictionaryEntry holds a key and a value from a dictionary.
    // It is returned by IDictionaryEnumerator::GetEntry().

	//[Compact]
    public class DictionaryEntry<TKey, TValue>
    {
        private TKey _key;
        private TValue _value;
    
        // Constructs a new DictionaryEnumerator by setting the Key
        // and Value fields appropriately.
        public DictionaryEntry(TKey key, TValue value) {
            _key = key;
            _value = value;
        }

        public TKey Key {
            get {
                return _key;
            }
            
            set {
                _key = value;
            }
        }

        public TValue Value {
            get {
                return _value;
            }

            set {
                _value = value;
            }
        }
    }
}
