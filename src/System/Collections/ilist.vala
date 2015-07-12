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

    public interface IList : Gee.List, ICollection
    {
        // Adds an item to the list.  The exact position in the list is 
        // implementation-dependent, so while ArrayList may always insert
        // in the last available location, a SortedList most likely would not.
        // The return value is the position the new element was inserted in.
        public virtual int Add(Object value) {
			add(value);
			return size;
		}
    
        // Returns whether the list contains a particular item.
        public virtual bool Contains(Object value) {
			return contains(value);
		}
    
        // Removes all items from the list.
        public virtual void Clear() {
			clear();
		}

        public abstract bool IsReadOnly { get; }

        public abstract bool IsFixedSize { get; }
        
        // Returns the index of a particular item, if it is in the list.
        // Returns -1 if the item isn't in the list.
        public virtual int IndexOf(Object value) {
			return index_of(value);
		}
        // Inserts value into the list at position index.
        // index must be non-negative and less than or equal to the 
        // number of elements in the list.  If index equals the number
        // of items in the list, then value is appended to the end.
        public virtual void Insert(int index, Object value) {
			set(index, value);
		}
    
        // Removes an item from the list.
        public virtual void Remove(Object value) {
			remove(value);
		}
    
        // Removes the item at position index.
        public virtual void RemoveAt(int index) {
			remove_at(index);
		}
    }

}
