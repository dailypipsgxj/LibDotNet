// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
/*============================================================
**
** Interface:  ICollection
** 
** <OWNER>[....]</OWNER>
**
**
** Purpose: Base interface for all generic collections.
**
** 
===========================================================*/
namespace System.Collections.Generic {
    using System;
    using System.Runtime.CompilerServices;
    using System.Diagnostics.Contracts;

    // Base interface for all collections, defining enumerators, size, and 
    // synchronization methods.

    // Note that T[] : IList<T>, and we want to ensure that if you use
    // IList<YourValueType>, we ensure a YourValueType[] can be used 
    // without jitting.  Hence the TypeDependencyAttribute on SZArrayHelper.
    // This is a special hack internally though - see VM\compile.cpp.
    // The same attribute is on IEnumerable<T> and ICollection<T>.

	[GenericAccessors]
    public interface ICollection<T> : Object, Gee.Collection<T>, IEnumerable<T>
    {
        // Number of items in the collections.        
        public abstract int Count { get; }

        public virtual IEnumerator iterator()
		{
			return GetEnumerator();
		}

        public abstract bool IsReadOnly { get; }

        public virtual void Add(T item) {
			add(item);
		}

        public virtual void Clear() {
			clear();
		}

        public virtual bool Contains(T item) {
			return contains (item);
		}
                
        // CopyTo copies a collection into an Array, starting at a particular
        // index into the array.
        // 
        public virtual void CopyTo(T[] array, int arrayIndex) {
			foreach (T item in this) {
				array[arrayIndex++] = item;
			}
		}
                
        //void CopyTo(int sourceIndex, T[] destinationArray, int destinationIndex, int count);

        public virtual bool Remove(T item) {
			return remove(item);
		}
    }

}
