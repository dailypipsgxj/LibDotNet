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
** Purpose: Base interface for all dictionaries.
**
** 
===========================================================*/
namespace System.Collections {
    using System;
    using System.Diagnostics.Contracts;

    // An IDictionary is a possibly unordered set of key-value pairs.
    // Keys can be any non-null object.  Values can be any object.
    // You can look up a value in an IDictionary via the default indexed
    // property, Items.  

    public interface IDictionary : Gee.Map, ICollection
    {
        // Interfaces are not serializable
        // The Item property provides methods to read and edit entries 
        // in the Dictionary.
        //abstract Object get (Object key) {}

        //abstract void set (Object key) {}
    
        // Returns a collections of the keys in this dictionary.
        public abstract ICollection Keys {
            owned get;
        }
    
        // Returns a collections of the values in this dictionary.
        public abstract ICollection Values {
            owned get;
        }
    
        // Returns whether this dictionary contains a particular key.
        //
        public virtual bool Contains(Object key) {
			return has_key(key);
		}
    
        // Adds a key-value pair to the dictionary.
        // 
        public virtual void Add(Object key, Object value) {
			set(key, value);
		}
    
        // Removes all pairs from the dictionary.
        public virtual void Clear() {
			clear();
		}
    
        abstract bool IsReadOnly 
        { get; }

        abstract bool IsFixedSize
        { get; }

        // Returns an IDictionaryEnumerator for this dictionary.
        public abstract IDictionaryEnumerator GetEnumerator();
    
        // Removes a particular key from the dictionary.
        //
        public virtual void Remove(Object key) {
			unset(key);
		}
    }

}
