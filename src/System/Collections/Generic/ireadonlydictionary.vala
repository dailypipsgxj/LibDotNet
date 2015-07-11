// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
/*============================================================
**
** Interface:  IReadOnlyDictionary<TKey, TValue>
** 
** <OWNER>[....]</OWNER>
**
** Purpose: Base interface for read-only generic dictionaries.
** 
===========================================================*/
using System;
using System.Diagnostics.Contracts;

namespace System.Collections.Generic
{
    // Provides a read-only view of a generic dictionary.
    public interface IReadOnlyDictionary<TKey, TValue> : IReadOnlyCollection<KeyValuePair<TKey, TValue>>
    {
        public abstract bool ContainsKey(TKey key);
        public abstract bool TryGetValue(TKey key, out TValue value);

        //public abstract TValue get (TKey key) {}
        abstract IEnumerable<TKey> Keys { get; }
        abstract IEnumerable<TValue> Values { get; }
    }
}
