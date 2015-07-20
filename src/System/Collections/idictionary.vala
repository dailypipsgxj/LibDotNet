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

    public interface IDictionary : ICollection, IEnumerable
    {

        //public abstract bool IsFixedSize { get; }
        //public abstract bool IsReadOnly { get; }

        // Interfaces are not serializable
        // The Item property provides methods to read and edit entries 
        // in the Dictionary.
		public abstract GLib.Object get (GLib.Object key);
        public abstract void set (GLib.Object key);
    
        // Returns a collections of the keys in this dictionary.
        public abstract ICollection? Keys { owned get; private set; }
        // Returns a collections of the values in this dictionary.
        public abstract ICollection? Values { owned get; }
 
        // Adds a key-value pair to the dictionary.
        // 
        public abstract void Add(GLib.Object key, GLib.Object value);
 
        // Removes all pairs from the dictionary.
        public abstract void Clear();
            
        // Returns whether this dictionary contains a particular key.
        //
        public abstract bool Contains(GLib.Object key);

        // Returns an IDictionaryEnumerator for this dictionary.
        public abstract IDictionaryEnumerator GetEnumerator();
    
        // Removes a particular key from the dictionary.
        //
        public abstract void Remove(GLib.Object key);
    }

}
