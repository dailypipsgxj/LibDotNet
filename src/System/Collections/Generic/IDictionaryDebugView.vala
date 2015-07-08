// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System.Diagnostics;

namespace System.Collections.Generic
{
    internal class IDictionaryDebugView<K, V>
    {
        private   IDictionary<K, V> _dict;

        public IDictionaryDebugView(IDictionary<K, V> dictionary)
        {
            if (dictionary == null)
                throw ArgumentNullException("dictionary");

            _dict = dictionary;
        }
// [DebuggerBrowsable(DebuggerBrowsableState.RootHidden)]

        public KeyValuePair<K, V>[] Items
        {
            get
            {
                KeyValuePair<K, V>[] items = new KeyValuePair<K, V>[_dict.Count];
                _dict.CopyTo(items, 0);
                return items;
            }
        }
    }

    internal class DictionaryKeyCollectionDebugView<TKey, TValue>
    {
        private   ICollection<TKey> _collection;

        public DictionaryKeyCollectionDebugView(ICollection<TKey> collection)
        {
            if (collection == null)
                throw ArgumentNullException("collection");

            _collection = collection;
        }
// [DebuggerBrowsable(DebuggerBrowsableState.RootHidden)]

        public TKey[] Items
        {
            get
            {
                TKey[] items = new TKey[_collection.Count];
                _collection.CopyTo(items, 0);
                return items;
            }
        }
    }

    internal class DictionaryValueCollectionDebugView<TKey, TValue>
    {
        private   ICollection<TValue> _collection;

        public DictionaryValueCollectionDebugView(ICollection<TValue> collection)
        {
            if (collection == null)
                throw ArgumentNullException("collection");

            _collection = collection;
        }
// [DebuggerBrowsable(DebuggerBrowsableState.RootHidden)]

        public TValue[] Items
        {
            get
            {
                TValue[] items = new TValue[_collection.Count];
                _collection.CopyTo(items, 0);
                return items;
            }
        }
    }
}
