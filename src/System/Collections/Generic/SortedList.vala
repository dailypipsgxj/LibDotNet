// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System;
using System.Diagnostics;

namespace System.Collections.Generic
{
    // The SortedDictionary class implements a generic sorted list of keys 
    // and values. Entries in a sorted list are sorted by their keys and 
    // are accessible both by key and by index. The keys of a sorted dictionary
    // can be ordered either according to a specific IComparer 
    // implementation given when the sorted dictionary is instantiated, or 
    // according to the IComparable implementation provided by the keys 
    // themselves. In either case, a sorted dictionary does not allow entries
    // with duplicate or null keys.
    // 
    // A sorted list internally maintains two arrays that store the keys and
    // values of the entries. The capacity of a sorted list is the allocated
    // length of these internal arrays. As elements are added to a sorted list, the
    // capacity of the sorted list is automatically increased as required by
    // reallocating the internal arrays.  The capacity is never automatically 
    // decreased, but users can call either TrimExcess or 
    // Capacity  ly.
    // 
    // The GetKeyList and GetValueList methods of a sorted list
    // provides access to the keys and values of the sorted list in the form of
    // List implementations. The List objects returned by these
    // methods are aliases for the underlying sorted list, so modifications
    // made to those lists are directly reflected in the sorted list, and vice
    // versa.
    // 
    // The SortedList class provides a convenient way to create a sorted
    // copy of another dictionary, such as a Hashtable. For example:
    // 
    // Hashtable h = new Hashtable();
    // h.Add(...);
    // h.Add(...);
    // ...
    // SortedList s = new SortedList(h);
    // 
    // The last line above creates a sorted list that contains a copy of the keys
    // and values stored in the hashtable. In this particular example, the keys
    // will be ordered according to the IComparable interface, which they
    // all must implement. To impose a different ordering, SortedList also
    // has a constructor that allows a specific IComparer implementation to
    // be specified.
    // 

    public class SortedList<TKey, TValue> : Dictionary<TKey, TValue>
    {
		/**
		 * The values' equality testing function.
		 */
		[CCode (notify = false)]
		internal CompareDataFunc<TKey> value_compare_func {
			private set {}
			get {
				return (CompareDataFunc<TKey>)_value_compare_func.Compare;
			}
		}

		protected IComparer<TKey> _value_compare_func;

		
        public SortedList(IComparer<TKey>? comparer = null, int capacity = 4)
        {
			base();
			_value_compare_func = (Comparer<TKey>)comparer ?? Comparer<TKey>.Default<TKey>();
        }

        // Constructs a new sorted dictionary with a given IComparer
        // implementation and a given initial capacity. The sorted list is
        // initially empty, but will have room for the given number of elements
        // before any reallocations are required. The elements of the sorted list
        // are ordered according to the given IComparer implementation. If
        // comparer is null, the elements are compared to each other using
        // the IComparable interface, which in that case must be implemented
        // by the keys of all entries added to the sorted list.
        // 
        public SortedList.WithCapacity(int capacity = 4, IComparer<TKey>? comparer = null){
			this(comparer, capacity);
        }


        // Returns the capacity of this sorted list. The capacity of a sorted list
        // represents the allocated length of the internal arrays used to store the
        // keys and values of the list, and thus also indicates the maximum number
        // of entries the list can contain before a reallocation of the internal
        // arrays is required.
        // 
        public int Capacity
        {
            get
            {
                return 	Capacity;
;
            }
            set
            {
				Capacity = value;
            }
        }
        
        
        public override void set(TKey key, TValue value)
        {
            int i = IndexOfKey(key);
            if (i >= 0)
				throw new ArgumentException.ADDING_DUPLICATE("SR.Argument_AddingDuplicate");
            //Insert(~i, key, value);
        }

        public int IndexOfKey(TKey key)
        {
			uint hash_value = key_hash_func (key);
			uint index = hash_value % _array_size;
			Node<TKey,TValue>** node = &_nodes[index];
			while ((*node) != null && (hash_value != (*node)->key_hash || !(bool)key_equal_func ((*node)->key, key))) {
				node = &((*node)->next);
				index--;
			}
			if (*node != null) { 
				return (int)index;
			}
			return -1;
        }

        
	}
}
