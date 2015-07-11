// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
/*============================================================
**
** Interface:  IDictionary
** 
** <OWNER>[....]</OWNER>
**
**
** Purpose: Base interface for all generic dictionaries.
**
** 
===========================================================*/
namespace System.Collections.Generic {
    using System;
    using System.Diagnostics.Contracts;

    // An IDictionary is a possibly unordered set of key-value pairs.
    // Keys can be any non-null object.  Values can be any object.
    // You can look up a value in an IDictionary via the default indexed
    // property, Items.  
    public interface IDictionary<TKey, TValue> : Gee.Map, ICollection<KeyValuePair<TKey, TValue>>
    {
        // Interfaces are not serializable
        // The Item property provides methods to read and edit entries 
        // in the Dictionary.
        //public abstract TValue get (TKey key) {}

        //public abstract void set (TKey key) {}
    
        // Returns a collections of the keys in this dictionary.
        public abstract ICollection<TKey> Keys {
            get;
        }
    
        // Returns a collections of the values in this dictionary.
        public abstract ICollection<TValue> Values {
            get;
        }
    
        // Returns whether this dictionary contains a particular key.
        //
        public virtual bool ContainsKey(TKey key) {
			return has_key(key);
		}

        public virtual bool ContainsValue(TValue value)
        {
            return (value in values);
        }

    
        // Adds a key-value pair to the dictionary.
        // 
        public virtual void Add(TKey key, TValue value) {
			set(key, value);
		}
    
        // Removes a particular key from the dictionary.
        //
        public virtual bool Remove(TKey key) {
			unset(key);
		}

        public abstract bool TryGetValue(TKey key, out TValue value) {
		    if (has_key(key)) {
                value = get(key);
                return true;
            }
            value = default(TValue);
            return false;
		}
		
		private static abstract bool IsCompatibleKey(Object key)
        {
            return (key is TKey);
        }

		
    }

}
