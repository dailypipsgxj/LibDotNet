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

	//[GenericAccessors]
    public interface ICollection<T> : GLib.Object
    {
		/**
		 * The number of items in this collection.
		 */
		public abstract int size { get; }

        // Number of items in the collections.        
        public abstract int Count { get; }

        public abstract bool IsReadOnly { get; }

		/**
		 * Adds an item to this collection. Must not be called on read-only
		 * collections.
		 *
		 * @param item the item to add to the collection
		 *
		 * @return     true if the collection has been changed, false otherwise
		 */
		public abstract void Add (T item);

		/**
		 * Removes all items from this collection. Must not be called on
		 * read-only collections.
		 */
        public abstract void Clear();

		/**
		 * Determines whether this collection contains the specified item.
		 *
		 * @param item the item to locate in the collection
		 *
		 * @return     true if item is found, false otherwise
		 */
		public abstract bool contains (T item);

        public virtual bool Contains(T item) {
			return contains (item);
		}
                
        // CopyTo copies a collection into an Array, starting at a particular
        // index into the array.
        // 
        public abstract void CopyTo(GLib.Array<T> array, int arrayIndex);

		/**
		 * Removes the first occurrence of an item from this collection. Must not
		 * be called on read-only collections.
		 *
		 * @param item the item to remove from the collection
		 *
		 * @return     true if the collection has been changed, false otherwise
		 */
        public abstract bool Remove(T item);
    }

}
