// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

/*=============================================================================
**
** Class: ReadOnlyCollectionBase
**
** Purpose: Provides the abstract base class for a
**          strongly typed non-generic read-only collection.
**
=============================================================================*/

using System;

namespace System.Collections
{
    // Useful base class for typed collections where items derive from Object

    public abstract class ReadOnlyCollectionBase : ICollection, IEnumerable
    {
        private ArrayList _list;

        protected ArrayList InnerList
        {
            get
            {
                if (_list == null)
                    _list = new ArrayList();
                return _list;
            }
        }

        public virtual int Count
        {
            get { return InnerList.Count; }
        }

        bool IsSynchronized
        {
            get { return InnerList.IsSynchronized; }
        }
        
        Object SyncRoot
        {
            get { return InnerList.SyncRoot; }
        }

        void CopyTo(Array array, int index)
        {
            InnerList.CopyTo(array, index);
        }

        public virtual IEnumerator GetEnumerator()
        {
            return InnerList.GetEnumerator();
        }
    }
}
