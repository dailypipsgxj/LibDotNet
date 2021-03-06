// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System.Diagnostics;

namespace System.Collections.Generic
{
    internal class ICollectionDebugView<T>
    {
        private   ICollection<T> _collection;

        public ICollectionDebugView(ICollection<T> collection)
        {
            if (collection == null)
            {
                throw ArgumentNullException("collection");
            }

            _collection = collection;
        }
// [DebuggerBrowsable(DebuggerBrowsableState.RootHidden)]

        public T[] Items
        {
            get
            {
                T[] items = new T[_collection.Count];
                _collection.CopyTo(items, 0);
                return items;
            }
        }
    }
}
