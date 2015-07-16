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
** Purpose: Base interface for all generic lists.
**
** 
===========================================================*/
namespace System.Collections.Generic {
    
    using System;
    //using System.Collections;
    using System.Runtime.CompilerServices;
    using System.Diagnostics.Contracts;

    // An IList is an ordered collection of objects.  The exact ordering
    // is up to the implementation of the list, ranging from a sorted
    // order to insertion order.  

    // Note that T[] : IList<T>, and we want to ensure that if you use
    // IList<YourValueType>, we ensure a YourValueType[] can be used 
    // without jitting.  Hence the TypeDependencyAttribute on SZArrayHelper.
    // This is a special hack internally though - see VM\compile.cpp.
    // The same attribute is on IEnumerable<T> and ICollection<T>.

	//[GenericAccessors]
    public interface IList<T> : GLib.Object
    {
		
		/**
		 * Returns the item at the specified index in this list.
		 *
		 * @param index zero-based index of the item to be returned
		 *
		 * @return      the item at the specified index in the list
		 */
		public abstract T? get (int index);

		/**
		 * Sets the item at the specified index in this list.
		 *
		 * @param index zero-based index of the item to be set
		 */
		public abstract void set (int index, T item);
	
       	/**
		 * Returns the index of the first occurrence of the specified item in
		 * this list.
		 *
		 * @return the index of the first occurrence of the specified item, or
		 *         -1 if the item could not be found
		 */
        public abstract int IndexOf(T item, int index = 0);
    
		/**
		 * Inserts an item into this list at the specified position.
		 *
		 * @param index zero-based index at which item is inserted
		 * @param item  item to insert into the list
		 */
        public abstract void Insert(int index, T item);
        
		/**
		 * Removes the item at the specified index of this list.
		 *
		 * @param index zero-based index of the item to be removed
		 */
		public abstract void RemoveAt(int index);
    }

}
