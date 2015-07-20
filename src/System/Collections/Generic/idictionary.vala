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
	[GenericAccessors]
    public interface IDictionary<TKey, TValue> :
		GLib.Object,
		IEnumerable<KeyValuePair<TKey, TValue>>
		//ICollection<KeyValuePair<TKey, TValue>> 
    {
        // Interfaces are not serializable
        // The Item property provides methods to read and edit entries 
        // in the Dictionary.
        public abstract TValue? get (TKey key);

        public abstract void set (TKey key, TValue value);
    
        // Returns a collections of the keys in this dictionary.
        public abstract ICollection<TKey> Keys {
            owned get;
        }
    
        // Returns a collections of the values in this dictionary.
        public abstract ICollection<TValue> Values {
            owned get;
        }
        
         // Adds a key-value pair to the dictionary.
        public abstract void Add(TKey key, TValue value);

        //public abstract bool Contains(KeyValuePair<TKey, TValue> keyValuePair, IEqualityComparer<KeyValuePair>? comparer = null);

   
        // Returns whether this dictionary contains a particular key.
        public abstract bool ContainsKey(TKey key);

        //public abstract bool ContainsValue(TValue value);
    
        // Removes a particular key from the dictionary.
        public abstract bool Remove(TKey key, TValue? value = null);

        public abstract bool TryGetValue(TKey key, out TValue value);
		
        // Returns an IEnumerator for this enumerable Object.  The enumerator provides
        // a simple way to access all the contents of a collection.
		//public abstract IEnumerator iterator ();

        //public virtual IEnumerator GetEnumerator() {
		//	return iterator();
		//}
		
    }

}
