// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
/*============================================================
**
** Interface:  IList
** 
** <OWNER>[....]</OWNER>
**
**
** Purpose: Base interface for all Lists.
**
** 
===========================================================*/
namespace System.Collections {
    
    using System;
    using System.Diagnostics.Contracts;

    // An IList is an ordered collection of objects.  The exact ordering
    // is up to the implementation of the list, ranging from a sorted
    // order to insertion order.  

	//[GenericAccessors]
    public interface IList : ICollection, IEnumerable
    {
		public abstract bool IsFixedSize { get; }
        public abstract bool IsReadOnly { get; }
		/**
		 * Returns the item at the specified index in this list.
		 *
		 * @param index zero-based index of the item to be returned
		 *
		 * @return      the item at the specified index in the list
		 */
		public abstract GLib.Object? get (int index);
		/**
		 * Sets the item at the specified index in this list.
		 *
		 * @param index zero-based index of the item to be set
		 */
		public abstract void set (int index, GLib.Object item);
		/**
		 * Adds an item to this list.
		 *
		 * @param item the item to add to the list
		 *
		 * @return the position the new element was inserted in
		 */
        public abstract int Add(GLib.Object item);

        // Removes all items from the list.
        public abstract void Clear();

		/**
		 * Determines whether this collection contains the specified item.
		 *
		 * @param item the item to locate in the collection
		 *
		 * @return     true if item is found, false otherwise
		 */
		public abstract bool contains (GLib.Object item);
       // Returns whether the list contains a particular item.
        public virtual bool Contains(GLib.Object item) {
			return contains(item);
		}
        // Returns the index of a particular item, if it is in the list.
        // Returns -1 if the item isn't in the list.
        public abstract int IndexOf(GLib.Object item);
        // Inserts value into the list at position index.
        // index must be non-negative and less than or equal to the 
        // number of elements in the list.  If index equals the number
        // of items in the list, then value is appended to the end.
        public virtual void Insert(int index, GLib.Object value) {
			set(index, value);
		}
        // Removes an item from the list.
        public abstract void Remove(GLib.Object value);
        // Removes the item at position index.
        public abstract void RemoveAt(int index);
    }

}
