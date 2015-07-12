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

    public class SortedList<TKey, TValue> :
        Gee.TreeMap<TKey, TValue>,
        IDictionary<TKey, TValue>,
        System.Collections.IDictionary,
        IReadOnlyDictionary<TKey, TValue>
    {
        private IComparer<TKey> _comparer;

        private KeyList _keyList;
        private ValueList _valueList;
        private Object _syncRoot;

        private const int DefaultCapacity = 4;

        // Constructs a new sorted list. The sorted list is initially empty and has
        // a capacity of zero. Upon adding the first element to the sorted list the
        // capacity is increased to DefaultCapacity, and then increased in multiples of two as
        // required. The elements of the sorted list are ordered according to the
        // IComparable interface, which must be implemented by the keys of
        // all entries added to the sorted list.
        public SortedList(IComparer<TKey>? comparer = null)
        {
            _comparer = (comparer == null) ? Comparer<TKey>.Default : comparer;
            base (comparer.Equals);
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
        public SortedList.WithCapacity(int capacity = DefaultCapacity, IComparer<TKey>? comparer = null){
			Capacity = capacity;
			this(comparer);
        }

        // Constructs a new sorted list containing a copy of the entries in the
        // given dictionary. The elements of the sorted list are ordered according
        // to the given IComparer implementation. If comparer is
        // null, the elements are compared to each other using the
        // IComparable interface, which in that case must be implemented
        // by the keys of all entries in the the given dictionary as well as keys
        // subsequently added to the sorted list.
        // 
        public SortedList.WithDictionary(IDictionary<TKey, TValue> dictionary, IComparer<TKey>? comparer = null){
			this(comparer);
			foreach (KeyValuePair<TKey,TValue> pair in dictionary) {
                set(pair.Key, pair.Value);
            }

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

        public IComparer<TKey> Comparer
        {
            get
            {
                return _comparer;
            }
        }


        // Returns the number of entries in this sorted list.
        // 
        public int Count
        {
            get
            {
                return size;
            }
        }

        // Returns a collection representing the keys of this sorted list. This
        // method returns the sameObjectas GetKeyList, but typed as an
        // ICollection instead of an IList.
        // 
        public IList<TKey> Keys
        {
            get
            {
                return GetKeyListHelper();
            }
        }

        // Returns a collection representing the values of this sorted list. This
        // method returns the sameObjectas GetValueList, but typed as an
        // ICollection instead of an IList.
        // 
        public IList<TValue> Values
        {
            get
            {
                return GetValueListHelper();
            }
        }


        private KeyList GetKeyListHelper()
        {
            if (_keyList == null)
                _keyList = new KeyList(this);
            return _keyList;
        }

        private ValueList GetValueListHelper()
        {
            if (_valueList == null)
                _valueList = new ValueList(this);
            return _valueList;
        }

        bool IsReadOnly
        {
            get { return read_only; }
        }

        bool IsFixedSize
        {
            get { return false; }
        }

        bool IsSynchronized
        {
            get { return false; }
        }

        // Synchronization root for this object.
        Object SyncRoot
        {
            get
            {
                return _syncRoot;
            }
        }


        // Checks if this sorted list contains an entry with the given value. The
        // values of the entries of the sorted list are compared to the given value
        // using the Object.Equals method. This method performs a linear
        // search and is substantially slower than the Contains
        // method.
        // 
        public bool ContainsValue(TValue value)
        {
            return (value in values);
        }

        private const int MaxArrayLength = 0X7FEFFFFF;

        // Ensures that the capacity of this sorted list is at least the given
        // minimum value. If the currect capacity of the list is less than
        // min, the capacity is increased to twice the current capacity or
        // to min, whichever is larger.
        private void EnsureCapacity(int min)
        {
        }

        // Returns the value of the entry at the given index.
        // 
        private TValue GetByIndex(int index)
        {
            if (index < 0 || index >= size)
                throw new ArgumentOutOfRangeException("index SR.ArgumentOutOfRange_Index");
            return this[index];
        }


        public IEnumerator<KeyValuePair<TKey, TValue>> GetEnumerator()
        {
            return new Enumerator(this, Enumerator.KeyValuePair);
        }

        // Returns the key of the entry at the given index.
        // 
        private TKey GetKey(int index)
        {
            if (index < 0 || index >= _size)
				throw new ArgumentOutOfRangeException("index SR.ArgumentOutOfRange_Index");
            return keys[index];
        }


        // Returns the value associated with the given key. If an entry with the
        // given key is not found, the returned value is null.
        // 
        /*
        public TValue get (TKey key) {
			int i = IndexOfKey(key);
			if (i >= 0)
				return _values[i];

			throw KeyNotFoundException();
			return default(TValue);
		}

        public void set (TKey key) {
			if (((Object)key) == null) throw ArgumentNullException("key");
			int i = Array.BinarySearch<TKey>(_keys, 0, _size, key, _comparer);
			if (i >= 0)
			{
				_values[i] = value;
				_version++;
				return;
			}
			Insert(~i, key, value);
		}
		*/


        // Returns the index of the entry with a given key in this sorted list. The
        // key is located through a binary search, and thus the average execution
        // time of this method is proportional to Log2(size), where
        // size is the size of this sorted list. The returned value is -1 if
        // the given key does not occur in this sorted list. Null is an invalid 
        // key value.
        //
        /* 
        public int IndexOfKey(TKey key)
        {
			
        }
        */

        // Returns the index of the first occurrence of an entry with a given value
        // in this sorted list. The entry is located through a linear search, and
        // thus the average execution time of this method is proportional to the
        // size of this sorted list. The elements of the list are compared to the
        // given value using the Object.Equals method.
        //
        /* 
        public int IndexOfValue(TValue value)
        {

        }
        */

        // Removes the entry at the given index. The size of the sorted list is
        // decreased by one.
        // 
        public void RemoveAt(int index)
        {
            if (index < 0 || index >= size) throw ArgumentOutOfRangeException("index SR.ArgumentOutOfRange_Index");
			
			unset (entries[index].key);

        }

        // Sets the capacity of this sorted list to the size of the sorted list.
        // This method can be used to minimize a sorted list's memory overhead once
        // it is known that no new elements will be added to the sorted list. To
        // completely clear a sorted list and release all memory referenced by the
        // sorted list, execute the following statements:
        // 
        // SortedList.Clear();
        // SortedList.TrimExcess();
        // 
        public void TrimExcess()
        {
        }

        [Compact]
        private class Enumerator : IEnumerator<KeyValuePair<TKey, TValue>>, System.Collections.IDictionaryEnumerator
        {
            private SortedList<TKey, TValue> _sortedList;
			private Gee.MapIterator _iterator;
            private TKey _key;
            private TValue _value;

            private int _getEnumeratorRetType;  // What should Enumerator.Current return?

            internal const int KeyValuePair = 1;
            internal const int DictEntry = 2;

            public Enumerator(SortedList<TKey, TValue> sortedList, int getEnumeratorRetType = 0)
            {
                _sortedList = sortedList;
                _iterator = sortedList.map_iterator();

                _getEnumeratorRetType = getEnumeratorRetType;
                _key = default(TKey);
                _value = default(TValue);
            }

            public void Dispose()
            {
                _key = default(TKey);
                _value = default(TValue);
            }


            Object Key
            {
                get
                {
                    if (_index == 0 || (_index == _sortedList.Count + 1))
                    {
                        throw new InvalidOperationException("SR.InvalidOperation_EnumOpCantHappen");
                    }

                    return _key;
                }
            }

            public bool MoveNext()
            {
				if (iterator.next()) {
			        _key = _iterator.get_key();
                    _value = _iterator.get_value();
					return true;
				}
                _key = default(TKey);
                _value = default(TValue);
                return false;
            }

            DictionaryEntry Entry
            {
                get
                {
                    if (_index == 0 || (_index == _sortedList.Count + 1))
                    {
                        throw InvalidOperationException(SR.InvalidOperation_EnumOpCantHappen);
                    }

                    return new DictionaryEntry(_key, _value);
                }
            }

            public KeyValuePair<TKey, TValue> Current
            {
                get
                {
                    return new KeyValuePair<TKey, TValue>(_key, _value);
                }
            }


            Object Value
            {
                get
                {
                    return _value;
                }
            }

            void Reset()
            {
				_iterator = _sortedList.map_iterator();
                _key = default(TKey);
                _value = default(TValue);
            }
        }

        private class SortedListKeyEnumerator : IEnumerator<TKey>, System.Collections.IEnumerator
        {
            private SortedList<TKey, TValue> _sortedList;
            private int _index;

            private TKey _currentKey;

            internal SortedListKeyEnumerator(SortedList<TKey, TValue> sortedList)
            {
                _sortedList = sortedList;
            }

            public void Dispose()
            {
                _index = 0;
                _currentKey = default(TKey);
            }

            public bool MoveNext()
            {
                if (_index < _sortedList.Count)
                {
                    _currentKey = _sortedList.keys[_index];
                    _index++;
                    return true;
                }
                _index = 0;
                _currentKey = default(TKey);
                return false;
            }

            public TKey Current
            {
                get
                {
                    return _currentKey;
                }
            }


            void Reset()
            {
                _index = 0;
                _currentKey = default(TKey);
            }
        }

        private class SortedListValueEnumerator : IEnumerator<TValue>, System.Collections.IEnumerator
        {
            private SortedList<TKey, TValue> _sortedList;
            private int _index;
            private TValue _currentValue;

            internal SortedListValueEnumerator(SortedList<TKey, TValue> sortedList)
            {
                _sortedList = sortedList;
            }

            public void Dispose()
            {
                _index = 0;
                _currentValue = default(TValue);
            }

            public bool MoveNext()
            {
                if (_index < _sortedList.Count)
                {
                    _currentValue = _sortedList.values[_index];
                    _index++;
                    return true;
                }
				_index = 0;
                _currentValue = default(TValue);
                return false;
            }

            public TValue Current
            {
                get
                {
                    return _currentValue;
                }
            }

            void Reset()
            {
                _index = 0;
                _currentValue = default(TValue);
            }
        }

        private class KeyList : IList<TKey>, System.Collections.ICollection
        {
            private SortedList<TKey, TValue> _dict;

            internal KeyList(SortedList<TKey, TValue> dictionary)
            {
                _dict = dictionary;
            }

            public int Count
            {
                get { return _dict.Count; }
            }

            public bool IsReadOnly
            {
                get { return true; }
            }

            bool IsSynchronized
            {
                get { return false; }
            }

            Object SyncRoot
            {
                get { return ((ICollection)_dict).SyncRoot; }
            }

            public void Add(TKey key)
            {
                throw new NotSupportedException("SR.NotSupported_SortedListNestedWrite");
            }

            public void Clear()
            {
                throw new NotSupportedException("SR.NotSupported_SortedListNestedWrite");
            }

            public bool Contains(TKey key)
            {
                return _dict.ContainsKey(key);
            }

            public void Insert(int index, TKey value)
            {
                throw new NotSupportedException(SR.NotSupported_SortedListNestedWrite);
            }

            public TKey get(int index) {
                 return _dict.GetKey(index);
            }


            public IEnumerator<TKey> GetEnumerator()
            {
                return new SortedListKeyEnumerator(_dict);
            }

            public int IndexOf(TKey key)
            {
				for (int i = 0; i < _dict.size; i++) {
					if (key == entries[i].key) {
						return i;
					}
				}
				return -1;
            }

            public bool Remove(TKey key)
            {
                throw new NotSupportedException("SR.NotSupported_SortedListNestedWrite");
                // return false;
            }

            public void RemoveAt(int index)
            {
                throw new NotSupportedException("SR.NotSupported_SortedListNestedWrite");
            }
        }

        private class ValueList : IList<TValue>, System.Collections.ICollection
        {
            private SortedList<TKey, TValue> _dict;

            internal ValueList(SortedList<TKey, TValue> dictionary)
            {
                _dict = dictionary;
            }

            public int Count
            {
                get { return _dict.size; }
            }

            public bool IsReadOnly
            {
                get { return true; }
            }

            bool IsSynchronized
            {
                get { return false; }
            }

            Object SyncRoot
            {
                get { return ((ICollection)_dict).SyncRoot; }
            }

            public void Add(TValue key)
            {
                throw new NotSupportedException("SR.NotSupported_SortedListNestedWrite");
            }

            public void Clear()
            {
                throw new NotSupportedException("SR.NotSupported_SortedListNestedWrite");
            }

            public bool Contains(TValue value)
            {
                return _dict.ContainsValue(value);
            }

            public void CopyTo(TValue[] array, int arrayIndex)
            {
                // defer error checking to Array.Copy
                //Array.Copy(_dict._values, 0, array, arrayIndex, _dict.Count);
            }

            public void Insert(int index, TValue value)
            {
                throw new NotSupportedException("SR.NotSupported_SortedListNestedWrite");
            }

            public TValue get (int index) {
                return _dict.GetByIndex(index);
            }

            public IEnumerator<TValue> GetEnumerator()
            {
                return new SortedListValueEnumerator(_dict);
            }

            public int IndexOf(TValue value)
            {
				for (int i = 0; i < _dict.size; i++) {
					if (value == entries[i].value) {
						return i;
					}
				}
				return -1;
            }

            public bool Remove(TValue value)
            {
                throw new NotSupportedException("SR.NotSupported_SortedListNestedWrite");
                // return false;
            }

            public void RemoveAt(int index)
            {
                throw new NotSupportedException("SR.NotSupported_SortedListNestedWrite");
            }
        }
    }
}
