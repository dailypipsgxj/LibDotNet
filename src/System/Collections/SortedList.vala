// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

/*============================================================
**
** Class:  SortedList
**
** Purpose: Represents a collection of key/value pairs
**          that are sorted by the keys and are accessible
**          by key and by index.
**
===========================================================*/

using System;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;
using System.Diagnostics.Contracts;
using System.Globalization;

namespace System.Collections
{
    // The SortedList class implements a sorted list of keys and values. Entries in
    // a sorted list are sorted by their keys and are accessible both by key and by
    // index. The keys of a sorted list can be ordered either according to a
    // specific IComparer implementation given when the sorted list is
    // instantiated, or according to the IComparable implementation provided
    // by the keys themselves. In either case, a sorted list does not allow entries
    // with duplicate keys.
    // 
    // A sorted list internally maintains two arrays that store the keys and
    // values of the entries. The capacity of a sorted list is the allocated
    // length of these internal arrays. As elements are added to a sorted list, the
    // capacity of the sorted list is automatically increased as required by
    // reallocating the internal arrays.  The capacity is never automatically 
    // decreased, but users can call either TrimToSize or 
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

    public class SortedList : Gee.TreeMap<Object, Object>, IDictionary, ICollection, IEnumerable
    {
        private IComparer _comparer;
        private KeyList _keyList;
        private ValueList _valueList;
        private Object _syncRoot;

        private const int _defaultCapacity = 16;

        // Constructs a new sorted list with a given IComparer
        // implementation and a given initial capacity. The sorted list is
        // initially empty, but will have room for the given number of elements
        // before any reallocations are required. The elements of the sorted list
        // are ordered according to the given IComparer implementation. If
        // comparer is null, the elements are compared to each other using
        // the IComparable interface, which in that case must be implemented
        // by the keys of all entries added to the sorted list.
        // 
        public SortedList(IComparer? comparer = null, int capacity = _defaultCapacity){
            if (comparer != null) _comparer = comparer;
            Capacity = capacity;
            base ();
        }

        // Constructs a new sorted list containing a copy of the entries in the
        // given dictionary. The elements of the sorted list are ordered according
        // to the given IComparer implementation. If comparer is
        // null, the elements are compared to each other using the
        // IComparable interface, which in that case must be implemented
        // by the keys of all entries in the the given dictionary as well as keys
        // subsequently added to the sorted list.
        // 
        public SortedList.FromDictionary(IDictionary d, IComparer? comparer = null){
			this (comparer);
        }

        // Returns the capacity of this sorted list. The capacity of a sorted list
        // represents the allocated length of the internal arrays used to store the
        // keys and values of the list, and thus also indicates the maximum number
        // of entries the list can contain before a reallocation of the internal
        // arrays is required.
        // 
        public virtual int Capacity
        {
            get { return size; }
            set { }
        }

        // Returns the number of entries in this sorted list.
        // 
        public virtual int Count
        {
            get { return size; }
        }

        // Returns a collection representing the keys of this sorted list. This
        // method returns the sameObjectas GetKeyList, but typed as an
        // ICollection instead of an IList.
        // 
        public new virtual ICollection Keys
        {
            owned get { return GetKeyList(); }
        }

        // Returns a collection representing the values of this sorted list. This
        // method returns the sameObjectas GetValueList, but typed as an
        // ICollection instead of an IList.
        // 
        public new virtual ICollection Values
        {
            owned get { return GetValueList(); }
        }

        // Is this SortedList read-only?
        public virtual bool IsReadOnly
        {
            get { return false; }
        }

        public virtual bool IsFixedSize
        {
            get { return false; }
        }

        // Is this SortedList synchronized (thread-safe)?
        public virtual bool IsSynchronized
        {
            get { return false; }
        }

        // Synchronization root for this object.
        public virtual Object SyncRoot
        {
            get { return _syncRoot; }
        }

        // Makes a virtually identical copy of this SortedList.  This is a shallow 
        // copy.  IE, the Objects in the SortedList are not cloned - we copy the 
        // references to those objects.
        public virtual Object Clone()
        {
            SortedList sl = new SortedList();
            foreach (var entry in this.entries) {
				sl.Add(entry.key, entry.value);
			}
            return sl;
        }

        // Checks if this sorted list contains an entry with the given key.
        // 
        public virtual bool ContainsKey(Object key)
        {
            // Yes, this is a SPEC'ed duplicate of Contains().
            return has_key(key);
        }

        // Checks if this sorted list contains an entry with the given value. The
        // values of the entries of the sorted list are compared to the given value
        // using the Object.Equals method. This method performs a linear
        // search and is substantially slower than the Contains
        // method.
        // 
        public virtual bool ContainsValue(Object value)
        {
            return (value in values);
        }


        // Copies the values in this SortedList to an KeyValuePairs array.
        // KeyValuePairs is different from Dictionary Entry in that it has special
        // debugger attributes on its fields.

        internal virtual KeyValuePairs[] ToKeyValuePairsArray()
        {
            KeyValuePairs[] array = new KeyValuePairs[size];
            var _keys = keys.to_array();
            var _values = values.to_array();
            for (int i = 0; i < size; i++)
            {
                array[i] = new KeyValuePairs(_keys[i], _values[i]);
            }
            return array;
        }

        // Ensures that the capacity of this sorted list is at least the given
        // minimum value. If the current capacity of the list is less than
        // min, the capacity is increased to twice the current capacity or
        // to min, whichever is larger.
        private void EnsureCapacity(int min)
        {
            Capacity = min;
        }

        // Returns the value of the entry at the given index.
        // 
        public virtual Object GetByIndex(int index)
        {
            if (index < 0 || index >= size)
                throw new ArgumentOutOfRangeException.INDEX("indexSR.ArgumentOutOfRange_Index");
            var _values = values.to_array();    
            return _values[index];
        }

        // Returns an IEnumerator for this sorted list.  If modifications 
        // made to the sorted list while an enumeration is in progress, 
        // the MoveNext and Remove methods
        // of the enumerator will throw an exception.
        //
        public virtual IDictionaryEnumerator GetEnumerator()
        {
            return new SortedListEnumerator(this, 0, size, SortedListEnumerator.DictEntry);
        }


        // Returns the key of the entry at the given index.
        // 
        public virtual Object GetKey(int index)
        {
			var _keys = keys.to_array();
            return _keys[index];
        }

        // Returns an IList representing the keys of this sorted list. The
        // returned list is an alias for the keys of this sorted list, so
        // modifications made to the returned list are directly reflected in the
        // underlying sorted list, and vice versa. The elements of the returned
        // list are ordered in the same way as the elements of the sorted list. The
        // returned list does not support adding, inserting, or modifying elements
        // (the Add, AddRange, Insert, InsertRange,
        // Reverse, Set, SetRange, and Sort methods
        // throw exceptions), but it does allow removal of elements (through the
        // Remove and RemoveRange methods or through an enumerator).
        // Null is an invalid key value.
        // 
        public virtual IList GetKeyList()
        {
            if (_keyList == null) _keyList = new KeyList(this);
            return (IList)_keyList;
        }

        // Returns an IList representing the values of this sorted list. The
        // returned list is an alias for the values of this sorted list, so
        // modifications made to the returned list are directly reflected in the
        // underlying sorted list, and vice versa. The elements of the returned
        // list are ordered in the same way as the elements of the sorted list. The
        // returned list does not support adding or inserting elements (the
        // Add, AddRange, Insert and InsertRange
        // methods throw exceptions), but it does allow modification and removal of
        // elements (through the Remove, RemoveRange, Set and
        // SetRange methods or through an enumerator).
        // 
        public virtual IList GetValueList()
        {
            if (_valueList == null) _valueList = new ValueList(this);
            return _valueList as IList;
        }

        // Returns the index of the entry with a given key in this sorted list. The
        // key is located through a binary search, and thus the average execution
        // time of this method is proportional to Log2(size), where
        // size is the size of this sorted list. The returned value is -1 if
        // the given key does not occur in this sorted list. Null is an invalid 
        // key value.
        // 
        public virtual int IndexOfKey(Object key)
        {
			var _keys = keys.to_array();
			for (int i = 0; i < size; i++) {
				if (_keys[i] == key) return i;
			}
			return -1;
        }

        // Returns the index of the first occurrence of an entry with a given value
        // in this sorted list. The entry is located through a linear search, and
        // thus the average execution time of this method is proportional to the
        // size of this sorted list. The elements of the list are compared to the
        // given value using the Object.Equals method.
        // 
        public virtual int IndexOfValue(Object value)
        {
			var _values = values.to_array();
			for (int i = 0; i < size; i++) {
				if (_values[i] == value) return i;
			}
			return -1;
        }

        // Removes the entry at the given index. The size of the sorted list is
        // decreased by one.
        // 
        public virtual void RemoveAt(int index)
        {
			var _keys = keys.to_array();
			unset(_keys[index]);
        }

        // Removes an entry from this sorted list. If an entry with the specified
        // key exists in the sorted list, it is removed. An ArgumentException is
        // thrown if the key is null.
        // 
        public virtual void Remove(Object key)
        {
			unset(key);
        }

        // Sets the value at an index to a given value.  The previous value of
        // the given entry is overwritten.
        // 
        public virtual void SetByIndex(int index, Object value)
        {
			set(GetKey(index), value);
        }

        // Returns a thread-safe SortedList.
        //
        public static SortedList Synchronized(SortedList list)
        {
            return new SyncSortedList(list);
        }

        // Sets the capacity of this sorted list to the size of the sorted list.
        // This method can be used to minimize a sorted list's memory overhead once
        // it is known that no new elements will be added to the sorted list. To
        // completely clear a sorted list and release all memory referenced by the
        // sorted list, execute the following statements:
        // 
        // sortedList.Clear();
        // sortedList.TrimToSize();
        // 
        public virtual void TrimToSize()
        {
            Capacity = size;
        }

        private class SyncSortedList : SortedList
        {
            private SortedList _list;
            private Object _root;


            internal SyncSortedList(SortedList list)
            {
                _list = list;
                _root = list.SyncRoot;
            }

            public override int Count
            {
                get { lock (_root) { return _list.Count; } }
            }

            public override Object SyncRoot
            {
                get { return _root; }
            }

            public override bool IsReadOnly
            {
                get { return _list.IsReadOnly; }
            }

            public override bool IsFixedSize
            {
                get { return _list.IsFixedSize; }
            }


            public override bool IsSynchronized
            {
                get { return true; }
            }

            public override Object get (Object key)
			{
				lock (_root)
				{
					return _list[key];
				}
			}
			
            public override void set (Object key, Object value)
			{
				lock (_root)
				{
					_list.Add (key,value);
				}
			}

            public void Add(Object key, Object value)
            {
                lock (_root)
                {
                    _list.Add(key, value);
                }
            }

            public override int Capacity
            {
                get { lock (_root) { return _list.Capacity; } }
                set { }
            }

            public void Clear()
            {
                lock (_root)
                {
                    _list.Clear();
                }
            }

            public override Object Clone()
            {
                lock (_root)
                {
                    return _list.Clone();
                }
            }

            public bool Contains(Object key)
            {
                lock (_root)
                {
                    return _list.Contains(key);
                }
            }

            public override bool ContainsKey(Object key)
            {
                lock (_root)
                {
                    return _list.ContainsKey(key);
                }
            }

            public override bool ContainsValue(Object key)
            {
                lock (_root)
                {
                    return _list.ContainsValue(key);
                }
            }

            public void CopyTo(Array array, int index)
            {
                lock (_root)
                {
                    _list.CopyTo(array, index);
                }
            }

            public override Object GetByIndex(int index)
            {
                lock (_root)
                {
                    return _list.GetByIndex(index);
                }
            }

            public override IDictionaryEnumerator GetEnumerator()
            {
                lock (_root)
                {
                    return _list.GetEnumerator();
                }
            }

            public override Object GetKey(int index)
            {
                lock (_root)
                {
                    return _list.GetKey(index);
                }
            }

            public override IList GetKeyList()
            {
                lock (_root)
                {
                    return _list.GetKeyList();
                }
            }

            public override IList GetValueList()
            {
                lock (_root)
                {
                    return _list.GetValueList();
                }
            }

            public override int IndexOfKey(Object key)
            {
                lock (_root)
                {
                    return _list.IndexOfKey(key);
                }
            }

            public override int IndexOfValue(Object value)
            {
                lock (_root)
                {
                    return _list.IndexOfValue(value);
                }
            }

            public override void RemoveAt(int index)
            {
                lock (_root)
                {
                    _list.RemoveAt(index);
                }
            }

            public override void Remove(Object key)
            {
                lock (_root)
                {
                    _list.Remove(key);
                }
            }

            public override void SetByIndex(int index, Object value)
            {
                lock (_root)
                {
                    _list.SetByIndex(index, value);
                }
            }

            internal override KeyValuePairs[] ToKeyValuePairsArray()
            {
                return _list.ToKeyValuePairsArray();
            }

            public override void TrimToSize()
            {
                lock (_root)
                {
                    _list.TrimToSize();
                }
            }
        }


        private class SortedListEnumerator : Object, IDictionaryEnumerator, IEnumerator
        {
            private SortedList _sortedList;
			private Object _currentElement { get; set;}
			private Gee.MapIterator<Object, Object> _iterator { get; set;}
            
            
            private int _startIndex;        // Store for Reset.
            private int _endIndex;

            private int _getObjectRetType;  // What should GetObject return?

            internal const int Keys = 1;
            internal const int Values = 2;
            internal const int DictEntry = 3;

            public SortedListEnumerator(SortedList sortedList, int index, int count, int getObjRetType)
            {
                _sortedList = sortedList;
                _startIndex = index;
                _endIndex = index + count;
                _getObjectRetType = getObjRetType;
            }

            public virtual Object Key
            {
                owned get
                {
                    return _iterator.get_key();
                }
            }


            public virtual DictionaryEntry Entry
            {
                owned get
                {
                    return new DictionaryEntry(_iterator.get_key(),_iterator.get_value());
                }
            }

            public virtual Object Current
            {
                owned get
                {
                    if (_getObjectRetType == Keys)
                        return _iterator.get_key();
                    else if (_getObjectRetType == Values)
                        return _iterator.get_value();
                    else
                        return new DictionaryEntry(_iterator.get_key(), _iterator.get_value()) as Object;
                }
            }

            public virtual Object Value
            {
                owned get
                {
                    return _iterator.get_value();
                }
            }

            public virtual void Reset()
            {
				_iterator = _sortedList.map_iterator();
            }
        }

        private class KeyList : SortedList
        {
            private SortedList _sortedList;

            internal KeyList(SortedList sortedList)
            {
                _sortedList = sortedList;
            }

            public override int Count
            {
                get { return _sortedList.size; }
            }

            public override bool IsReadOnly
            {
                get { return true; }
            }

            public override bool IsFixedSize
            {
                get { return true; }
            }

            public override bool IsSynchronized
            {
                get { return _sortedList.IsSynchronized; }
            }

            public override Object SyncRoot
            {
                get { return _sortedList.SyncRoot; }
            }

            public virtual int Add(Object key)
            {
                throw new NotSupportedException.SORTEDLISTNESTEDWRITE("SR.NotSupported_SortedListNestedWrite");
            }

            public virtual void Clear()
            {
                throw new NotSupportedException.SORTEDLISTNESTEDWRITE("SR.NotSupported_SortedListNestedWrite");
            }

            public virtual bool Contains(Object key)
            {
                return _sortedList.Contains(key);
            }


            public virtual void Insert(int index, Object value)
            {
                throw new NotSupportedException.SORTEDLISTNESTEDWRITE("SR.NotSupported_SortedListNestedWrite");
            }

            public new virtual Object get(int index)
			{
				return _sortedList.GetKey(index);
			}

            public new virtual void set(int index)
            {
                 throw new NotSupportedException.KEYCOLLECTIONSET("SR.NotSupported_KeyCollectionSet");
            }

            public override IDictionaryEnumerator GetEnumerator()
            {
                return new SortedListEnumerator(_sortedList, 0, _sortedList.Count, SortedListEnumerator.Keys);
            }

            public virtual int IndexOf(Object key)
            {
                int i = 0; //Array.BinarySearch(_sortedList._keys, 0,
                          //                 _sortedList.Count, key, _sortedList._comparer);
                if (i >= 0) return i;
                return -1;
            }

            public override void Remove(Object key)
            {
                throw new NotSupportedException.SORTEDLISTNESTEDWRITE("SR.NotSupported_SortedListNestedWrite");
            }

            public override void RemoveAt(int index)
            {
                throw new NotSupportedException.SORTEDLISTNESTEDWRITE("SR.NotSupported_SortedListNestedWrite");
            }
        }

        private class ValueList : SortedList
        {
            private SortedList _sortedList;

            internal ValueList(SortedList sortedList)
            {
                _sortedList = sortedList;
            }

            public override int Count
            {
                get { return _sortedList.size; }
            }

            public override bool IsReadOnly
            {
                get { return true; }
            }

            public override bool IsFixedSize
            {
                get { return true; }
            }

            public override bool IsSynchronized
            {
                get { return _sortedList.IsSynchronized; }
            }

            public override Object SyncRoot
            {
                get { return _sortedList.SyncRoot; }
            }

            public int Add(Object key)
            {
                throw new NotSupportedException.SORTEDLISTNESTEDWRITE("SR.NotSupported_SortedListNestedWrite");
            }

            public virtual void Clear()
            {
                throw new NotSupportedException.SORTEDLISTNESTEDWRITE("SR.NotSupported_SortedListNestedWrite");
            }

            public virtual bool Contains(Object value)
            {
                return _sortedList.ContainsValue(value);
            }

            public virtual void CopyTo(Array array, int arrayIndex)
            {
                // defer error checking to Array.Copy
                //Array.Copy(_sortedList._values, 0, array, arrayIndex, _sortedList.Count);
            }

            public virtual void Insert(int index, Object value)
            {
                throw new NotSupportedException.SORTEDLISTNESTEDWRITE("SR.NotSupported_SortedListNestedWrite");
            }

            public new virtual Object get (int index)
			{
				return _sortedList.GetByIndex(index);
			}

            public new virtual void set (int index)
            {
               throw new NotSupportedException.SORTEDLISTNESTEDWRITE("SR.NotSupported_SortedListNestedWrite");
            }

            public override IDictionaryEnumerator GetEnumerator()
            {
                return new SortedListEnumerator(_sortedList, 0, _sortedList.Count, SortedListEnumerator.Values);
            }

            public virtual int IndexOf(Object value)
            {
                return -1; //Array.IndexOf(_sortedList._values, value, 0, _sortedList.Count);
            }

            public override void Remove(Object value)
            {
                throw new NotSupportedException.SORTEDLISTNESTEDWRITE("SR.NotSupported_SortedListNestedWrite");
            }

            public override void RemoveAt(int index)
            {
                throw new NotSupportedException.SORTEDLISTNESTEDWRITE("SR.NotSupported_SortedListNestedWrite");
            }
        }

    }
}
