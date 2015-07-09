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
#if CONTRACTS_FULL
// [ContractClass(typeof(IDictionaryContract))]

#endif // CONTRACTS_FULL
// [System.Runtime.InteropServices.ComVisible(true)]

    public interface IDictionary : ICollection
    {
        // Interfaces are not serializable
        // The Item property provides methods to read and edit entries 
        // in the Dictionary.
        abstract Object get (Object key) {}

        abstract void set (Object key) {}
    
        // Returns a collections of the keys in this dictionary.
        abstract ICollection Keys {
            get;
        }
    
        // Returns a collections of the values in this dictionary.
        abstract ICollection Values {
            get;
        }
    
        // Returns whether this dictionary contains a particular key.
        //
        abstract bool Contains(Object key);
    
        // Adds a key-value pair to the dictionary.
        // 
        abstract void Add(Object key, Object value);
    
        // Removes all pairs from the dictionary.
        abstract void Clear();
    
        abstract bool IsReadOnly 
        { get; }

        abstract bool IsFixedSize
        { get; }

        // Returns an IDictionaryEnumerator for this dictionary.
        abstract new IDictionaryEnumerator GetEnumerator();
    
        // Removes a particular key from the dictionary.
        //
        abstract void Remove(Object key);
    }

#if CONTRACTS_FULL
// [ContractClassFor(typeof(IDictionary))]

    internal abstract class IDictionaryContract : IDictionary
    {
        Object IDictionary. get (Object key) {
		{ return default(Object); }
            set { }
        }

        ICollection IDictionary.Keys {
            get {
                Contract.Ensures(Contract.Result<ICollection>() != null);
                //Contract.Ensures(Contract.Result<ICollection>().Count == ((ICollection)this).Count);
                return default(ICollection);
            }
        }

        ICollection IDictionary.Values {
            get {
                Contract.Ensures(Contract.Result<ICollection>() != null);
                return default(ICollection);
            }
        }

        bool IDictionary.Contains(Object key)
        {
            return default(bool);
        }

        void IDictionary.Add(Object key, Object value)
        {
        }

        void IDictionary.Clear()
        {
        }

        bool IDictionary.IsReadOnly {
            get { return default(bool); }
        }

        bool IDictionary.IsFixedSize { 
            get { return default(bool); }
        }

        IDictionaryEnumerator IDictionary.GetEnumerator()
        {
            Contract.Ensures(Contract.Result<IDictionaryEnumerator>() != null);
            return default(IDictionaryEnumerator);
        }

        void IDictionary.Remove(Object key)
        {
        }

         ICollection members

        void ICollection.CopyTo(Array array, int index)
        {
        }

        int ICollection.Count { 
            get {
                return default(int);
            }
        }

        Object ICollection.SyncRoot {
            get {
                return default(Object);
            }
        }

        bool ICollection.IsSynchronized {
            get { return default(bool); }
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return default(IEnumerator);
        }

         ICollection Members
    }
#endif // CONTRACTS_FULL
}
