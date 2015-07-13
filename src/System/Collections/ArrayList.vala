// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

/*============================================================
**
** Class:  ArrayList
**
** Purpose: Implements a dynamically sized List as an array,
**          and provides many convenience methods for treating
**          an array as an IList.
**
===========================================================*/

using System;
using System.Runtime;
using System.Security;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;
using System.Diagnostics.Contracts;

namespace System.Collections
{
    // Implements a variable-size List that uses an array of objects to store the
    // elements. A ArrayList has a capacity, which is the allocated length
    // of the internal array. As elements are added to a ArrayList, the capacity
    // of the ArrayList is automatically increased as required by reallocating the
    // internal array.
    // 

    public class ArrayList : Gee.ArrayList<Object>, IList, IEnumerable, ICollection
    {
        private Object _syncRoot;
        private const int _defaultCapacity = 4;

        // Constructs a ArrayList with a given initial capacity. The list is
        // initially empty, but will have room for the given number of elements
        // before any reallocations are required.
        // 
        public ArrayList(int capacity = _defaultCapacity)
        {
			base ();
        }

        // Constructs a ArrayList, copying the contents of the given collection. The
        // size and capacity of the new list will both be equal to the size of the
        // given collection.
        // 
        public ArrayList.WithCollection(ICollection c)
        {
			base();
			foreach (var item in c) {
				Add(item);
			}
        }

        // Gets and sets the capacity of this list.  The capacity is the size of
        // the internal array used to hold items.  When set, the internal 
        // array of the list is reallocated to the given capacity.
        // 
        public virtual int Capacity
        {
            get { return size; }
            set
            {
                if (value < size)
                {
                    throw new ArgumentOutOfRangeException.VALUE("SmallCapacity");
                }
            }
        }

        // Read-only property describing how many elements are in the List.
        public virtual int Count
        {
            get { return size; }
        }

        public virtual bool IsFixedSize
        {
            get { return false; }
        }

        // Is this ArrayList read-only?
        public virtual bool IsReadOnly
        {
            get { return false; }
        }

        // Is this ArrayList synchronized (thread-safe)?
        public virtual bool IsSynchronized
        {
            get { return false; }
        }

        // Synchronization root for this object.
        public virtual Object SyncRoot
        {
            get {  return _syncRoot; }
        }


        // Creates a ArrayList wrapper for a particular IList.  This does not
        // copy the contents of the IList, but only wraps the IList.  So any
        // changes to the underlying list will affect the ArrayList.  This would
        // be useful if you want to Reverse a subrange of an IList, or want to
        // use a generic BinarySearch or Sort method without implementing one yourself.
        // However, since these methods are generic, the performance may not be
        // nearly as good for some operations as they would be on the IList itself.
        //
        public static ArrayList Adapter(IList list)
        {
            return new IListWrapper(list);
        }


        // Adds the elements of the given collection to the end of this list. If
        // required, the capacity of the list is increased to twice the previous
        // capacity or the new size, whichever is larger.
        //
        public virtual void AddRange(ICollection c)
        {
            InsertRange(size, c);
        }

        // Searches a section of the list for a given element using a binary search
        // algorithm. Elements of the list are compared to the search value using
        // the given IComparer interface. If comparer is null, elements of
        // the list are compared to the search value using the IComparable
        // interface, which in that case must be implemented by all elements of the
        // list and the given search value. This method assumes that the given
        // section of the list is already sorted; if this is not the case, the
        // result will be incorrect.
        //
        // The method returns the index of the given value in the list. If the
        // list does not contain the given value, the method returns a negative
        // integer. The bitwise complement operator (~) can be applied to a
        // negative result to produce the index of the first element (if any) that
        // is larger than the given search value. This is also the index at which
        // the search value should be inserted into the list in order for the list
        // to remain sorted.
        // 
        // The method uses the Array.BinarySearch method to perform the
        // search.
        // 
        public virtual int BinarySearch(int index = 0, int count = Count-1, Object value, IComparer? comparer = null)
        {
			if (comparer == null) {
				return index_of(value);
			}
			return -1;
        }


        // Clones this ArrayList, doing a shallow copy.  (A copy is made of all
        // Object references in the ArrayList, but the Objects pointed to 
        // are not cloned).
        public virtual Object Clone()
        {
            ArrayList la = new ArrayList(size);
            foreach (var item in this) {
				la.Add(item);
			}
            return (Object)la;
        }


        // Copies a section of this list to the given array at the given index.
        // 
        // The method uses the Array.Copy method to copy the elements.
        // 
        public virtual void CopyToIndex(int index, Object[] array, int arrayIndex, int count)
        {
			for (int i = index; i < index+count; i++) {
				array[arrayIndex++] = get(i);
			}
        }

        // Ensures that the capacity of this list is at least the given minimum
        // value. If the current capacity of the list is less than min, the
        // capacity is increased to twice the current capacity or to min,
        // whichever is larger.
        private void EnsureCapacity(int min)
        {
        }

        // Returns a list wrapper that is fixed at the current size.  Operations
        // that add or remove items will fail, however, replacing items is allowed.
        //
        public static IList FixedSize(IList list)
        {
            return new FixedSizeList(list);
        }

        // Returns an enumerator for a section of this list with the given
        // permission for removal of elements. If modifications made to the list 
        // while an enumeration is in progress, the MoveNext and 
        // GetObject methods of the enumerator will throw an exception.
        //
        public virtual IEnumerator GetEnumerator()
        {
            //if (index < 0 && count < 0)
				return new ArrayListEnumeratorSimple(this);

            //return new ArrayListEnumerator(this, index, count);
        }

        // Inserts the elements of the given collection at a given index. If
        // required, the capacity of the list is increased to twice the previous
        // capacity or the new size, whichever is larger.  Ranges may be added
        // to the end of the list by setting index to the ArrayList's size.
        //
        public virtual void InsertRange(int index, ICollection c)
        {
			var col = new Gee.ArrayList<Object> ();
			foreach (var item in c) {
				col.add(item);
			}
			insert_all(index, col);
        }

        // Returns the index of the last occurrence of a given value in a range of
        // this list. The list is searched backwards, starting at index
        // startIndex and upto count elements. The elements of
        // the list are compared to the given value using the Object.Equals
        // method.
        // 
        // This method uses the Array.LastIndexOf method to perform the
        // search.
        // 
        public virtual int LastIndexOf(Object value, int startIndex = size, int count =  1)
        {
			//Ugh
			return index_of(value);
        }

        public static IList ReadOnly(IList list)
        {
            return new ReadOnlyList(list);
        }


        // Removes a range of elements from this list.
        // 
        public virtual void RemoveRange(int index, int count)
        {
			while (count > 0)
			{
				RemoveAt(index);
				count--;
			}
        }

        // Returns an IList that contains count copies of value.
        //
        public static ArrayList Repeat(Object value, int count = 1)
        {
            ArrayList list = new ArrayList((count > _defaultCapacity) ? count : _defaultCapacity);
            for (int i = 0; i < count; i++)
                list.Add(value);
            return list;
        }

        // Reverses the elements in a range of this list. Following a call to this
        // method, an element in the range given by index and count
        // which was previously located at index i will now be located at
        // index index + (index + count - i - 1).
        // 
        // This method uses the Array.Reverse method to reverse the
        // elements.
        // 
        public virtual void Reverse(int index = 0, int count = Count)
        {
			int i = index;
			int j = index + count - 1;
			while (i < j)
			{
				Object tmp = (Object)this[i];
				this[i++] = this[j];
				this[j--] = tmp;
			}
        }

        // Sets the elements starting at the given index to the elements of the
        // given collection.
        //
        public virtual void SetRange(int index, ICollection c)
        {
			var col = new Gee.ArrayList<Object> ();
			foreach (var item in c) {
				col.add(item);
			}
			insert_all(index, col);
        }

        public virtual ArrayList GetRange(int index, int count)
        {
            return new Range(this, index, count);
        }

        // Sorts the elements in a section of this list. The sort compares the
        // elements to each other using the given IComparer interface. If
        // comparer is null, the elements are compared to each other using
        // the IComparable interface, which in that case must be implemented by all
        // elements of the list.
        // 
        // This method uses the Array.Sort method to sort the elements.
        // 
        public virtual void Sort(int index = 0, int count = Count, IComparer? comparer = null)
        {
			sort((CompareDataFunc)comparer.Compare);
        }

        // Returns a thread-safe wrapper around an IList.
        //
        public static IList Synchronized(IList list)
        {
            return new SyncIList(list);
        }

        // ToArray returns a new array of a particular type containing the contents 
        // of the ArrayList.  This requires copying the ArrayList and potentially
        // downcasting all elements.  This copy may fail and is an O(n) operation.
        // Internally, this implementation calls Array.Copy.
        //

        public virtual Object[] ToArray()
        {
            return (Object[])to_array();
        }

        // Sets the capacity of this list to the size of the list. This method can
        // be used to minimize a list's memory overhead once it is known that no
        // new elements will be added to the list. To completely clear a list and
        // release all memory referenced by the list, execute the following
        // statements:
        // 
        // list.Clear();
        // list.TrimToSize();
        // 
        public virtual void TrimToSize()
        {
            Capacity = size;
        }

        // This class wraps an IList, exposing it as a ArrayList
        // Note this requires reimplementing half of ArrayList...
        private class IListWrapper : ArrayList
        {
            private IList _list;

            internal IListWrapper(IList list)
            {
                _list = list;
            }

            public override int Capacity
            {
                get { return _list.Count; }
                set { }
            }

            public override int Count
            {
                get { return _list.Count; }
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
                get { return _list.IsSynchronized; }
            }

            public override Object get(int index)
			{
				return (Object)_list.get(index);
			}

            public new void set(int index, Object value)
			{
				_list.set(index, value);
			}

            public override Object SyncRoot
            {
                get { return _list.SyncRoot; }
            }

            public int Add(Object obj)
            {
                return _list.Add(obj);
            }

            public override void AddRange(ICollection c)
            {
                InsertRange(Count, c);
            }

            public override int BinarySearch(int index = 0, int count = Count-1, Object value, IComparer? comparer = null)

            {
				if (comparer == null) {
					return index_of(value);
				}
				return -1;
            }

            public void Clear()
            {
                _list.Clear();
            }

            public new Object Clone()
            {
                // This does not do a shallow copy of _list into a ArrayList!
                // This clones the IListWrapper, creating another wrapper class!
                return new IListWrapper(_list);
            }

            public bool Contains(Object obj)
            {
                return _list.Contains(obj);
            }

            public void CopyTo(Array<Object> array, int index)
            {
                _list.CopyTo(array, index);
            }

            public new void CopyToIndex(int index, Object[] array, int arrayIndex, int count)
            {
				for (int i = index; i < index+count; i++) {
					array[arrayIndex++] = (Object)_list.get(i);
				}

            }

            public new IEnumerator GetEnumerator(int index = 0, int count = Count)
            {
                return new IListWrapperEnumWrapper(this, index, count);
            }

            public int IndexOf(Object value, int startIndex = 0, int count = Count)
            {
				return -1;
            }

            public void Insert(int index, Object obj)
            {
                _list.Insert(index, obj);
            }

            public new void InsertRange(int index, ICollection c)
            {
                if (c.Count > 0)
                {
                    ArrayList al = _list as ArrayList;
                    if (al != null)
                    {
                        // We need to special case ArrayList. 
                        // When c is a range of _list, we need to handle this in a special way.
                        // See ArrayList.InsertRange for details.
                        al.InsertRange(index, c);
                    }
                    else
                    {
                        IEnumerator en = c.GetEnumerator();
                        while (en.MoveNext())
                        {
                            _list.Insert(index++, en.Current);
                        }
                    }
                }
            }

            public override int LastIndexOf(Object value, int startIndex = 0, int count = Count)
            {
				return -1;
            }

            public void Remove(Object value)
            {
                int index = IndexOf(value);
                if (index >= 0)
                    RemoveAt(index);
            }

            public void RemoveAt(int index)
            {
                _list.RemoveAt(index);
            }

            public override void RemoveRange(int index, int count)
            {
                while (count > 0)
                {
                    _list.RemoveAt(index);
                    count--;
                }
            }

            public override void Reverse(int index, int count)
            {
                int i = index;
                int j = index + count - 1;
                while (i < j)
                {
                    Object tmp = (Object)_list[i];
                    _list[i++] = _list[j];
                    _list[j--] = tmp;
                }
            }

            public override void SetRange(int index, ICollection c)
            {
                if (index < 0 || index > _list.Count - c.Count)
                {
                    throw new ArgumentOutOfRangeException.INDEX("index SR.ArgumentOutOfRange_Index");
                }

                if (c.Count > 0)
                {
                    IEnumerator en = c.GetEnumerator();
                    while (en.MoveNext())
                    {
                        _list[index++] = en.Current;
                    }
                }
            }

            public override ArrayList GetRange(int index, int count)
            {
                return new Range(this, index, count);
            }

            public override void Sort(int index =0, int count = Count, IComparer? comparer = null)
            {
                Object[] array = new Object[count];
                //CopyTo(index, array, 0, count);
                //Array.Sort(array, 0, count, comparer);
                for (int i = 0; i < count; i++)
                    _list[i + index] = array[i];
            }


            public override Object[] ToArray()
            {
                Object[] array = new Object[Count];
                //_list.CopyTo(array, 0);
                return array;
            }

            // This is the enumerator for an IList that's been wrapped in another
            // class that implements all of ArrayList's methods.
            private class IListWrapperEnumWrapper : Object, IEnumerator
            {
				private Object _currentElement { get; set;}
				private Gee.Iterator<Object> _iterator { get; set;}
                private IEnumerator _en;
                private int _remaining;
                private int _initialStartIndex; // for reset
                private int _initialCount;      // for reset
                private bool _firstCall;        // firstCall to MoveNext


                public IListWrapperEnumWrapper(IListWrapper listWrapper, int startIndex, int count)
                {
                    _en = listWrapper.GetEnumerator();
                    _initialStartIndex = startIndex;
                    _initialCount = count;
                    while (startIndex-- > 0 && _en.MoveNext()) ;
                    _remaining = count;
                    _firstCall = true;
                }

                public bool MoveNext()
                {
                    if (_firstCall)
                    {
                        _firstCall = false;
                        return _remaining-- > 0 && _en.MoveNext();
                    }
                    if (_remaining < 0)
                        return false;
                    bool r = _en.MoveNext();
                    return r && _remaining-- > 0;
                }

                public Object Current
                {
                    owned get
                    {
                        return _en.Current;
                    }
                }

                public void Reset()
                {
                    _en.Reset();
                    int startIndex = _initialStartIndex;
                    while (startIndex-- > 0 && _en.MoveNext()) ;
                    _remaining = _initialCount;
                    _firstCall = true;
                }
            }
        }


        private class SyncArrayList : ArrayList
        {
            private ArrayList _list;
            private Object _root;

            internal SyncArrayList(ArrayList list){
				base();
                _list = list;
                _root = list.SyncRoot;
            }

            public override int Capacity
            {
                get
                {
                    lock (_root)
                    {
                        return _list.Capacity;
                    }
                }
  
                set
                {
                    lock (_root)
                    {
                        _list.Capacity = value;
                    }
                }
            }

            public override int Count
            {
                get { lock (_root) { return _list.Count; } }
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

            public override Object get (int index)
			{
				lock (_root)
				{
					return _list[index];
				}
			}

            public override void set (int index, Object value)
            {
				lock (_root)
				{
					_list[index] = value;
				}
			}

            public override Object SyncRoot
            {
                get { return _root; }
            }

            public int Add(Object value)
            {
                lock (_root)
                {
                    return _list.Add(value);
                }
            }

            public override void AddRange(ICollection c)
            {
                lock (_root)
                {
                    _list.AddRange(c);
                }
            }

			public override int BinarySearch(int index = 0, int count = Count-1, Object value, IComparer? comparer = null)
            {
                lock (_root)
                {
                    return -1;
                }
            }
  
            public int BinarySearchFromIndex(int index, int count, Object value, IComparer? comparer = null)
            {
                lock (_root)
                {
                    return _list.BinarySearch(index, count, value, comparer);
                }
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
                    return new SyncArrayList((ArrayList)_list.Clone());
                }
            }

            public bool Contains(Object item)
            {
                lock (_root)
                {
                    return _list.Contains(item);
                }
            }


            public void CopyTo(int index, Array array, int arrayIndex = 0, int count = Count)
            {
                lock (_root)
                {
                    //_list.CopyTo(index, array, arrayIndex, count);
                }
            }

            public override IEnumerator GetEnumerator()
            {
                lock (_root)
                {
                    return _list.GetEnumerator();
                }
            }

            public int IndexOf(Object value, int startIndex = 0, int count = Count)
            {
                lock (_root)
                {
                    return -1;
                }
            }

            public void Insert(int index, Object value)
            {
                lock (_root)
                {
                    _list.Insert(index, value);
                }
            }

            public override void InsertRange(int index, ICollection c)
            {
                lock (_root)
                {
                    _list.InsertRange(index, c);
                }
            }

            public override int LastIndexOf(Object value, int startIndex = 0, int count = Count)
            {
                lock (_root)
                {
                    return _list.LastIndexOf(value, startIndex, count);
                }
            }

            public void Remove(Object value)
            {
                lock (_root)
                {
                    _list.Remove(value);
                }
            }

            public void RemoveAt(int index)
            {
                lock (_root)
                {
                    _list.RemoveAt(index);
                }
            }
  
            public override void RemoveRange(int index, int count)
            {
                lock (_root)
                {
                    _list.RemoveRange(index, count);
                }
            }
  
            public override void Reverse(int index, int count)
            {
                lock (_root)
                {
                    _list.Reverse(index, count);
                }
            }
  
            public override void SetRange(int index, ICollection c)
            {
                lock (_root)
                {
                    _list.SetRange(index, c);
                }
            }
  
            public override ArrayList GetRange(int index, int count)
            {
                lock (_root)
                {
                    return _list.GetRange(index, count);
                }
            }

            public new void Sort(IComparer? comparer = null)
            {
                lock (_root)
                {
                    //_list.Sort(comparer);
                }
            }
  
            public void SortFromIndex(int index, int count, IComparer comparer)
            {
                lock (_root)
                {
                    _list.Sort(index, count, comparer);
                }
            }

            public override Object[] ToArray()
            {
                lock (_root)
                {
                    return _list.ToArray();
                }
            }

            public override void TrimToSize()
            {
                lock (_root)
                {
                    _list.TrimToSize();
                }
            }
        }


        private class SyncIList : ArrayList
        {
            private IList _list;
            private Object _root;

            internal SyncIList(IList list)
            {
                _list = list;
                _root = list.SyncRoot;
            }

            public override int Count
            {
                get { lock (_root) { return _list.Count; } }
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

            public override Object get (int index)
            {
				lock (_root)
				{
					return this as Object;
				}
            }

            public override void set (int index, Object value)
			{
				lock (_root)
				{
					_list[index] = value;
				}
			}

            public override Object SyncRoot
            {
                get { return _root; }
            }

            public int Add(Object value)
            {
                lock (_root)
                {
                    return _list.Add(value);
                }
            }


            public virtual void Clear()
            {
                lock (_root)
                {
                    _list.Clear();
                }
            }

            public virtual bool Contains(Object item)
            {
                lock (_root)
                {
                    return _list.Contains(item);
                }
            }

            public virtual void CopyTo(Array array, int index)
            {
                lock (_root)
                {
                    //_list.CopyTo(array, index);
                }
            }

            public override IEnumerator GetEnumerator()
            {
                lock (_root)
                {
                    return _list.GetEnumerator();
                }
            }

            public virtual int IndexOf(Object value)
            {
                lock (_root)
                {
                    return _list.IndexOf(value);
                }
            }

            public virtual void Insert(int index, Object value)
            {
                lock (_root)
                {
                    _list.Insert(index, value);
                }
            }

            public virtual void Remove(Object value)
            {
                lock (_root)
                {
                    _list.Remove(value);
                }
            }

            public virtual void RemoveAt(int index)
            {
                lock (_root)
                {
                    _list.RemoveAt(index);
                }
            }
        }

        private class FixedSizeList : ArrayList
        {
            private IList _list;

            internal FixedSizeList(IList l)
            {
                _list = l;
            }

            public override int Count
            {
                get { return _list.Count; }
            }

            public override bool IsReadOnly
            {
                get { return _list.IsReadOnly; }
            }

            public override bool IsFixedSize
            {
                get { return true; }
            }

            public override  bool IsSynchronized
            {
                get { return _list.IsSynchronized; }
            }

            public override Object get (int index)
			{
				return (Object)_list[index];
			}

            public override void set (int index, Object value)
			{
				_list[index] = value;
			}

            public override Object SyncRoot
            {
                get { return _list.SyncRoot; }
            }

            public virtual int Add(Object obj)
            {
                throw new NotSupportedException.FIXEDSIZECOLLECTION("SR.NotSupported_FixedSizeCollection");
            }

            public virtual void Clear()
            {
                throw new NotSupportedException.FIXEDSIZECOLLECTION("SR.NotSupported_FixedSizeCollection");
            }

            public virtual bool Contains(Object obj)
            {
                return _list.Contains(obj);
            }

            public virtual void CopyTo(Array<Object> array, int index)
            {
                _list.CopyTo(array, index);
            }

            public override IEnumerator GetEnumerator()
            {
                return _list.GetEnumerator();
            }

            public virtual int IndexOf(Object value)
            {
                return _list.IndexOf(value);
            }

            public virtual void Insert(int index, Object obj)
            {
                throw new NotSupportedException.FIXEDSIZECOLLECTION("SR.NotSupported_FixedSizeCollection");
            }

            public virtual void Remove(Object value)
            {
                throw new NotSupportedException.FIXEDSIZECOLLECTION("SR.NotSupported_FixedSizeCollection");
            }

            public virtual void RemoveAt(int index)
            {
                throw new NotSupportedException.FIXEDSIZECOLLECTION("SR.NotSupported_FixedSizeCollection");
            }
        }

        private class FixedSizeArrayList : ArrayList
        {
            private ArrayList _list;

            internal FixedSizeArrayList(ArrayList l)
            {
                _list = l;
            }

            public override int Count
            {
                get { return _list.Count; }
            }

            public override bool IsReadOnly
            {
                get { return _list.IsReadOnly; }
            }

            public override bool IsFixedSize
            {
                get { return true; }
            }

            public override bool IsSynchronized
            {
                get { return _list.IsSynchronized; }
            }

            public override Object get (int index)
			{
				return _list[index];
			}

            public override void set (int index, Object value)
			{
				_list[index] = value;
			}

            public override Object SyncRoot
            {
                get { return _list.SyncRoot; }
            }

            public int Add(Object obj)
            {
                throw new NotSupportedException.FIXEDSIZECOLLECTION("SR.NotSupported_FixedSizeCollection");
            }

            public override void AddRange(ICollection c)
            {
                throw new NotSupportedException.FIXEDSIZECOLLECTION("SR.NotSupported_FixedSizeCollection");
            }
  
            public new int BinarySearch(int index, int count, Object value, IComparer comparer)
            {
                return _list.BinarySearch(index, count, value, comparer);
            }

            public override int Capacity
            {
                get { return _list.Capacity; }
  
                set { throw new NotSupportedException.FIXEDSIZECOLLECTION("SR.NotSupported_FixedSizeCollection"); }
            }

            public void Clear()
            {
                throw new NotSupportedException.FIXEDSIZECOLLECTION("SR.NotSupported_FixedSizeCollection");
            }

            public override Object Clone()
            {
                FixedSizeArrayList arrayList = new FixedSizeArrayList(_list);
                arrayList._list = (ArrayList)_list.Clone();
                return arrayList;
            }

            public bool Contains(Object obj)
            {
                return _list.Contains(obj);
            }

            public void CopyTo(Array array, int index)
            {
                //_list.CopyTo(array, index);
            }
  
            public new void CopyToIndex(int index, Array array, int arrayIndex, int count)
            {
                //_list.CopyTo(index, array, arrayIndex, count);
            }

            public override IEnumerator GetEnumerator()
            {
                return _list.GetEnumerator();
            }

            public int IndexOf(Object value, int startIndex = 0, int count = Count)
            {
                return _list.IndexOf(value);
            }

            public void Insert(int index, Object obj)
            {
                throw new NotSupportedException.FIXEDSIZECOLLECTION("SR.NotSupported_FixedSizeCollection");
            }
  
            public override void InsertRange(int index, ICollection c)
            {
                throw new NotSupportedException.FIXEDSIZECOLLECTION("SR.NotSupported_FixedSizeCollection");
            }

            public override int LastIndexOf(Object value, int startIndex = 0, int count = Count)
            {
                return _list.LastIndexOf(value, startIndex, count);
            }

            public void Remove(Object value)
            {
                throw new NotSupportedException.FIXEDSIZECOLLECTION("SR.NotSupported_FixedSizeCollection");
            }

            public void RemoveAt(int index)
            {
                throw new NotSupportedException.FIXEDSIZECOLLECTION("SR.NotSupported_FixedSizeCollection");
            }
  
            public override void RemoveRange(int index, int count)
            {
                throw new NotSupportedException.FIXEDSIZECOLLECTION("SR.NotSupported_FixedSizeCollection");
            }

  
            public override void SetRange(int index, ICollection c)
            {
                _list.SetRange(index, c);
            }

            public override ArrayList GetRange(int index, int count)
            {

                return new Range(this, index, count);
            }
  
            public override void Reverse(int index, int count)
            {
                _list.Reverse(index, count);
            }
  
            public new void Sort(int index, int count, IComparer comparer)
            {
                _list.Sort(index, count, comparer);
            }

            public override Object[] ToArray()
            {
                return _list.ToArray();
            }

            public override void TrimToSize()
            {
                throw new NotSupportedException.FIXEDSIZECOLLECTION("SR.NotSupported_FixedSizeCollection");
            }
        }

        private class ReadOnlyList : ArrayList
        {
            private IList _list;

            internal ReadOnlyList(IList l)
            {
                _list = l;
            }

            public override int Count
            {
                get { return _list.Count; }
            }

            public override bool IsReadOnly
            {
                get { return true; }
            }

            public override bool IsFixedSize
            {
                get { return true; }
            }

            public override  bool IsSynchronized
            {
                get { return _list.IsSynchronized; }
            }

            public override Object get (int index)
			{
				return (Object)_list[index];
			}


            public override void set (int index, Object value)
			{
				throw new NotSupportedException.READONLYCOLLECTION("SR.NotSupported_ReadOnlyCollection");
			}

            public override Object SyncRoot
            {
                get { return _list.SyncRoot; }
            }

            public virtual int Add(Object obj)
            {
                throw new NotSupportedException.READONLYCOLLECTION("SR.NotSupported_ReadOnlyCollection");
            }

            public virtual void Clear()
            {
                throw new NotSupportedException.READONLYCOLLECTION("SR.NotSupported_ReadOnlyCollection");
            }

            public virtual bool Contains(Object obj)
            {
                return _list.Contains(obj);
            }

            public virtual void CopyTo(Array array, int index)
            {
                //_list.CopyTo(array, index);
            }

            public override IEnumerator GetEnumerator()
            {
                return _list.GetEnumerator();
            }

            public virtual int IndexOf(Object value)
            {
                return _list.IndexOf(value);
            }

            public virtual void Insert(int index, Object obj)
            {
                throw new NotSupportedException.READONLYCOLLECTION("SR.NotSupported_ReadOnlyCollection");
            }

            public virtual void Remove(Object value)
            {
                throw new NotSupportedException.READONLYCOLLECTION("SR.NotSupported_ReadOnlyCollection");
            }

            public virtual void RemoveAt(int index)
            {
                throw new NotSupportedException.READONLYCOLLECTION("SR.NotSupported_ReadOnlyCollection");
            }
        }

        private class ReadOnlyArrayList : ArrayList
        {
            private ArrayList _list;

            internal ReadOnlyArrayList(ArrayList l)
            {
                _list = l;
            }

            public override int Count
            {
                get { return _list.Count; }
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
                get { return _list.IsSynchronized; }
            }

            public override Object get (int index)
			{
				return _list[index];
			}

            public override void set (int index, Object value)
			{
				throw new NotSupportedException.READONLYCOLLECTION("SR.NotSupported_ReadOnlyCollection");
			}

            public override Object SyncRoot
            {
                get { return _list.SyncRoot; }
            }

            public int Add(Object obj)
            {
                throw new NotSupportedException.READONLYCOLLECTION("SR.NotSupported_ReadOnlyCollection");
            }

            public override void AddRange(ICollection c)
            {
                throw new NotSupportedException.READONLYCOLLECTION("SR.NotSupported_ReadOnlyCollection");
            }
  
            public new int BinarySearch(int index, int count, Object value, IComparer comparer)
            {
                return _list.BinarySearch(index, count, value, comparer);
            }


            public override int Capacity
            {
                get { return _list.Capacity; }
  
                set
                { throw new NotSupportedException.READONLYCOLLECTION("SR.NotSupported_ReadOnlyCollection"); }
            }

            public void Clear()
            {
                throw new NotSupportedException.READONLYCOLLECTION("SR.NotSupported_ReadOnlyCollection");
            }

            public override Object Clone()
            {
                ReadOnlyArrayList arrayList = new ReadOnlyArrayList(_list);
                arrayList._list = (ArrayList)_list.Clone();
                return arrayList;
            }

            public bool Contains(Object obj)
            {
                return _list.Contains(obj);
            }

            public void CopyTo(int index, Array array, int arrayIndex = 0, int count = Count)
            {
                //_list.CopyTo(index, array, arrayIndex, count);
            }

            public override IEnumerator GetEnumerator()
            {
                return _list.GetEnumerator();
            }

            public int IndexOf(Object value, int startIndex = 0, int count = Count)
            {
                return _list.IndexOf(value);
            }

            public void Insert(int index, Object obj)
            {
                throw new NotSupportedException.READONLYCOLLECTION("SR.NotSupported_ReadOnlyCollection");
            }
  
            public override void InsertRange(int index, ICollection c)
            {
                throw new NotSupportedException.READONLYCOLLECTION("SR.NotSupported_ReadOnlyCollection");
            }

            public override int LastIndexOf(Object value, int startIndex = 0, int count = Count)
            {
                return _list.LastIndexOf(value, startIndex, count);
            }

            public void Remove(Object value)
            {
                throw new NotSupportedException.READONLYCOLLECTION("SR.NotSupported_ReadOnlyCollection");
            }

            public void RemoveAt(int index)
            {
                throw new NotSupportedException.READONLYCOLLECTION("SR.NotSupported_ReadOnlyCollection");
            }

  
            public override void RemoveRange(int index, int count)
            {
                throw new NotSupportedException.READONLYCOLLECTION("SR.NotSupported_ReadOnlyCollection");
            }
  
            public override void SetRange(int index, ICollection c)
            {
                throw new NotSupportedException.READONLYCOLLECTION("SR.NotSupported_ReadOnlyCollection");
            }

            public override ArrayList GetRange(int index, int count)
            {
                if (index < 0 || count < 0)
                    throw new ArgumentOutOfRangeException.NEEDNONNEGNUM((index < 0 ? "index" : "count"));
                if (Count - index < count)
                    throw new ArgumentException.INVALIDOFFSETLENGTH("SR.Argument_InvalidOffLen");

                return new Range(this, index, count);
            }

  
            public override void Reverse(int index, int count)
            {
                throw new NotSupportedException.READONLYCOLLECTION("SR.NotSupported_ReadOnlyCollection");
            }

  
            public override void Sort(int index = 0, int count = Count, IComparer? comparer = null)
            {
                throw new NotSupportedException.READONLYCOLLECTION("SR.NotSupported_ReadOnlyCollection");
            }

            public override Object[] ToArray()
            {
                return _list.ToArray();
            }

            public override void TrimToSize()
            {
                throw new NotSupportedException.READONLYCOLLECTION("SR.NotSupported_ReadOnlyCollection");
            }
        }


        // Implements an enumerator for a ArrayList. The enumerator uses the
        // internal version number of the list to ensure that no modifications are
        // made to the list while an enumeration is in progress.
        private class ArrayListEnumerator : Object, IEnumerator
        {
			private Object _currentElement { get; set;}
			private Gee.Iterator<Object> _iterator { get; set;}
            private ArrayList _list;
            private int _index;
            private int _endIndex;       // Where to stop.
            private int _version;
            private int _startIndex;     // Save this for Reset.

            internal ArrayListEnumerator(ArrayList list, int index, int count)
            {
                _list = list;
                _startIndex = index;
                _index = index - 1;
                _endIndex = _index + count;  // last valid index
                _currentElement = null;
            }

            public bool MoveNext()
            {
                if (_index < _endIndex)
                {
                    _currentElement = _list[++_index];
                    return true;
                }
                else
                {
                    _index = _endIndex + 1;
                }

                return false;
            }

            public Object Current
            {
                owned get
                {
                    if (_index < _startIndex)
                        throw new InvalidOperationException.ENUMNOTSTARTED("SR.InvalidOperation_EnumNotStarted");
                    else if (_index > _endIndex)
                    {
                        throw new InvalidOperationException.ENUMENDED("SR.InvalidOperation_EnumEnded");
                    }
                    return _currentElement;
                }
            }

            public void Reset()
            {
                _index = _startIndex - 1;
            }
        }

        // Implementation of a generic list subrange. An instance of this class
        // is returned by the default implementation of List.GetRange.
        private class Range : ArrayList
        {
            private ArrayList _baseList;
            private int _baseIndex;
            private int _baseSize;

            internal Range(ArrayList list, int index, int count){
				base();
                _baseList = list;
                _baseIndex = index;
                _baseSize = count;
            }


            public int Add(Object value)
            {
                _baseList.Insert(_baseIndex + _baseSize, value);
                
                return _baseSize++;
            }

            public override void AddRange(ICollection c)
            {
                int count = c.Count;
                if (count > 0)
                {
                    _baseList.InsertRange(_baseIndex + _baseSize, c);
                    
                    _baseSize += count;
                }
            }

            public override int BinarySearch(int index = 0, int count = Count, Object value, IComparer? comparer = null)
            {

                int i = _baseList.BinarySearch(_baseIndex + index, count, value, comparer);
                if (i >= 0) return i - _baseIndex;
                return i + _baseIndex;
            }

            public override int Capacity
            {
                get { return _baseList.Capacity; }
                set { }
            }


            public void Clear()
            {
                if (_baseSize != 0)
                {
                    _baseList.RemoveRange(_baseIndex, _baseSize);
                    
                    _baseSize = 0;
                }
            }

            public override Object Clone()
            {
                Range arrayList = new Range(_baseList, _baseIndex, _baseSize);
                arrayList._baseList = (ArrayList)_baseList.Clone();
                return arrayList;
            }

            public bool Contains(Object item)
            {
                if (item == null)
                {
                    for (int i = 0; i < _baseSize; i++)
                        if (_baseList[_baseIndex + i] == null)
                            return true;
                    return false;
                }
                else
                {
                    for (int i = 0; i < _baseSize; i++)
                        //if (_baseList[_baseIndex + i] != null && _baseList[_baseIndex + i].Equals(item))
                         //   return true;
                    return false;
                }
                return false;
            }

            public void CopyTo(Array array, int index)
            {
                //_baseList.CopyTo(_baseIndex, array, index, _baseSize);
            }

            public override void CopyToIndex(int index, Object[] array, int arrayIndex, int count)
            {
                //_baseList.CopyTo(_baseIndex + index, array, arrayIndex, count);
            }

            public override int Count
            {
                get
                {
                        return _baseSize;
                }
            }

            public override bool IsReadOnly
            {
                get { return _baseList.IsReadOnly; }
            }

            public override bool IsFixedSize
            {
                get { return _baseList.IsFixedSize; }
            }

            public override bool IsSynchronized
            {
                get { return _baseList.IsSynchronized; }
            }

            public override IEnumerator GetEnumerator()
            {
                return _baseList.GetEnumerator();
            }

            public override ArrayList GetRange(int index, int count)
            {
                return new Range(this, index, count);
            }

            public override Object SyncRoot
            {
                get
                {
                    return _baseList.SyncRoot;
                }
            }


            public int IndexOf(Object value, int startIndex = 0, int count = 0)
            {
                //int i = _baseList.IndexOf(value, _baseIndex + startIndex, count);
                int i = _baseList.IndexOf(value);
                if (i >= 0) return i - _baseIndex;
                return -1;
            }

            public void Insert(int index, Object value)
            {
                _baseList.Insert(_baseIndex + index, value);
                
                _baseSize++;
            }

            public override void InsertRange(int index, ICollection c)
            {

                int count = c.Count;
                if (count > 0)
                {
                    _baseList.InsertRange(_baseIndex + index, c);
                    _baseSize += count;
                    
                }
            }

            public override int LastIndexOf(Object value, int startIndex = 0, int count = Count)
            {
                if (_baseSize == 0)
                    return -1;

                if (startIndex >= _baseSize)
                    throw new ArgumentOutOfRangeException.INDEX("startIndex SR.ArgumentOutOfRange_Index");
                if (startIndex < 0)
                    throw new ArgumentOutOfRangeException.NEEDNONNEGNUM("startIndex SR.ArgumentOutOfRange_NeedNonNegNum");

                int i = _baseList.LastIndexOf(value, _baseIndex + startIndex, count);
                if (i >= 0) return i - _baseIndex;
                return -1;
            }

            // Don't need to override Remove

            public void RemoveAt(int index)
            {
                _baseList.RemoveAt(_baseIndex + index);
                
                _baseSize--;
            }

            public override void RemoveRange(int index, int count)
            {
                // No need to call _bastList.RemoveRange if count is 0.
                // In addition, _baseList won't change the version number if count is 0. 
                if (count > 0)
                {
                    _baseList.RemoveRange(_baseIndex + index, count);
                    
                    _baseSize -= count;
                }
            }

            public override void Reverse(int index, int count)
            {
                _baseList.Reverse(_baseIndex + index, count);
                
            }

            public override void SetRange(int index, ICollection c)
            {
                if (index < 0 || index >= _baseSize) throw new ArgumentOutOfRangeException.INDEX("index SR.ArgumentOutOfRange_Index");
                _baseList.SetRange(_baseIndex + index, c);
            }

            public override void Sort(int index = 0, int count = Count, IComparer? comparer = null)
            {
                _baseList.Sort(_baseIndex + index, count, comparer);
                
            }

            public override Object get (int index)
			{
				if (index < 0 || index >= _baseSize) throw new ArgumentOutOfRangeException.INDEX("index SR.ArgumentOutOfRange_Index");
				return _baseList[_baseIndex + index];
			}

            public override void set (int index, Object value)
			{
				if (index < 0 || index >= _baseSize) throw new ArgumentOutOfRangeException.INDEX("index SR.ArgumentOutOfRange_Index");
				_baseList[_baseIndex + index] = value;
				
			}

            public override Object[] ToArray()
            {
                Object[] array = new Object[_baseSize];
                //_baseList.CopyTo(_baseIndex, array, 0, _baseSize);
                return array;
            }

            public override void TrimToSize()
            {
                throw new NotSupportedException.RANGECOLLECTION("SR.NotSupported_RangeCollection");
            }
        }

        private class ArrayListEnumeratorSimple : Object, IEnumerator
        {
			private Object _currentElement { get; set;}
			private Gee.Iterator<Object> _iterator { get; set;}

            private ArrayList _list;
            private int _index;
            private bool _isArrayList;
            // thisObjectis used to indicate enumeration has not started or has terminated
            private static Object s_dummyObject = new Object();

            internal ArrayListEnumeratorSimple(ArrayList list)
            {
                _list = list;
                _index = -1;
                _isArrayList = (list.get_type() == typeof(ArrayList));
                _currentElement = s_dummyObject;
            }

            public bool MoveNext()
            {
                if (_isArrayList)
                {  // avoid calling virtual methods if we are operating on ArrayList to improve performance
                    if (_index < _list.size - 1)
                    {
                        _currentElement = _list[++_index];
                        return true;
                    }
                    else
                    {
                        _currentElement = s_dummyObject;
                        _index = _list.size;
                        return false;
                    }
                }
                else
                {
                    if (_index < _list.Count - 1)
                    {
                        _currentElement = _list[++_index];
                        return true;
                    }
                    else
                    {
                        _index = _list.Count;
                        _currentElement = s_dummyObject;
                        return false;
                    }
                }
            }

            public new Object Current
            {
                owned get
                {
					Object temp = _currentElement;
                    return temp;
                }
            }

            public void Reset()
            {
                _currentElement = s_dummyObject;
                _index = -1;
            }
        }

    }
}
