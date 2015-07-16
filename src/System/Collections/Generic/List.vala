// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
/*============================================================
**
** Class:  List
** 
** <OWNER>[....]</OWNER>
**
** Purpose: Implements a generic, dynamically sized list as an 
**          array.
**
** 
===========================================================*/
namespace System.Collections.Generic {

    using System;
    using System.Runtime;
    //using System.Runtime.Versioning;
    using System.Diagnostics;
    using System.Diagnostics.Contracts;
    //using System.Collections.ObjectModel;
    using System.Security.Permissions;


	public abstract class AbstractList<T> :
		GLib.Object,
   		IList<T>,
		ICollection<T>,
		IEnumerable<T>,
		System.Collections.ICollection,
		System.Collections.IEnumerable,
		System.Collections.IList,
		IReadOnlyCollection<T>,
		IReadOnlyList<T>
	{
		public abstract int size { get; }
		public abstract GLib.Type get_element_type ();
		public abstract int Capacity { get; set; }
		public abstract int Count { get; }
        public abstract bool IsFixedSize { get; }
        public abstract bool IsReadOnly { get; }
        public abstract bool IsSynchronized { get; }
		public abstract GLib.Object SyncRoot { get; }

		public abstract IEnumerator<T> iterator ();
		public abstract bool contains (T item);
        public abstract int IndexOf(T item, int startIndex = 0);
		public new abstract T? get (int index) ;
		public new abstract void set (int index, T item);
		public abstract void Add (T item);
        public abstract void AddRange(IEnumerable<T> collection);
		/*
        public abstract ReadOnlyCollection<T> AsReadOnly() {
            return new ReadOnlyCollection<T>(this);
        }
        */
        public abstract int BinarySearch(int index, int count, T item, IComparer<T> comparer);
		public abstract void Clear ();
        public abstract void CopyTo(GLib.Array<T> array, int arrayIndex);
        public abstract void ForEach(Action<T> action);
        public abstract IEnumerator<T> GetEnumerator();
        public abstract IList<T> GetRange(int index, int count);
        public abstract void InsertRange(int index, IEnumerable<T> collection);
		public abstract void Insert (int index, T item);
        public abstract int LastIndexOf(T item);
		public abstract bool Remove (T item);
		public abstract void RemoveAt (int index);
        public abstract int RemoveAll(Predicate<T> match);
        public abstract void RemoveRange(int index, int count);
        public abstract void Reverse();
        public abstract void Sort(IComparer<T>? comparer = null);
        public abstract void TrimExcess();

	}
	
    // Implements a variable-size List that uses an array of objects to store the
    // elements. A List has a capacity, which is the allocated length
    // of the internal array. As elements are added to a List, the capacity
    // of the List is automatically increased as required by reallocating the
    // internal array.
    // 
    public class List<T> : AbstractList<T>
	{
            
		private T[] _items = new T[4];
		private int _size;
		private GLib.EqualFunc _equal_func;
		// concurrent modification protection
		private int _stamp = 0;

		public override int size {
			get { return _size; }
		}

		public override GLib.Type get_element_type () {
			return typeof (T);
		}

        // Tets and sets the capacity of this list.  The capacity is the size of
        // the internal array used to hold items.  When set, the internal 
        // array of the list is reallocated to the given capacity.
        // 
        public override int Capacity {
            get { return _items.length; }
            set { set_capacity(value); }
        }

        // Read-only property describing how many elements are in the List.
        public override int Count {
            get { return _size; }
        }

        public override bool IsFixedSize { get { return false; } }
           
        // Is this List read-only?
        public override bool IsReadOnly {
            get { return false; }
        }

        // Is this List synchronized (thread-safe)?
        public override bool IsSynchronized {
            get { return false; }
        }
    
        // Synchronization root for this object.
        public override GLib.Object SyncRoot {
            get { return this as GLib.Object; }
        }

        // Constructs a List. The list is initially empty and has a capacity
        // of zero. Upon adding the first element to the list the capacity is
        // increased to 16, and then increased in multiples of two as required.
        public List(IEnumerable<T>? enumerable = null) {
			_equal_func = GLib.direct_equal;
			if (enumerable != null) {
				foreach (var item in enumerable) {
					Add(item);
				}
			}
        }


        public List.WithCapacity(int defaultCapacity = 4) {
			this();
			set_capacity (defaultCapacity);
        }

		public override IEnumerator<T> iterator () {
			return new Enumerator<T> (this);
		}

		public override bool contains (T item) {
			return (IndexOf (item) != -1);
		}
 
        // Returns the index of the first occurrence of a given value in a range of
        // this list. The list is searched forwards, starting at index
        // index and ending at count number of elements. The
        // elements of the list are compared to the given value using the
        // Object.Equals method.
        // 
        // This method uses the Array.IndexOf method to perform the
        // search.
        // 
        public override int IndexOf(T item, int startIndex = 0) {
			for (int index = 0; index < _size; index++) {
				if (_equal_func (_items[index], item)) {
					return index;
				}
			}
			return -1;
        }

		public override T? get (int index) {
			GLib.assert (index >= 0 && index < _size);
			return _items[index];
		}

		public override void set (int index, T item) {
			GLib.assert (index >= 0 && index < _size);
			_items[index] = item;
		}

		public override void Add (T item) {
			if (_size == _items.length) {
				grow_if_needed (1);
			}
			_items[_size++] = item;
			_stamp++;
		}

        // Adds the elements of the given collection to the end of this list. If
        // required, the capacity of the list is increased to twice the previous
        // capacity or the new size, whichever is larger.
        //
        public override void AddRange(IEnumerable<T> collection) {
            InsertRange(size, collection);
        }

		/*
        public override ReadOnlyCollection<T> AsReadOnly() {
            return new ReadOnlyCollection<T>(this);
        }
        */

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
        public override int BinarySearch(int index, int count, T item, IComparer<T> comparer) {
			return -1;
        }

		public override void Clear () {
			for (int index = 0; index < _size; index++) {
				_items[index] = null;
			}
			_size = 0;
			_stamp++;
		}

        public override void CopyTo(GLib.Array<T> array, int arrayIndex) {
			;
		}

        public override void ForEach(Action<T> action) {

        }

        public override IEnumerator<T> GetEnumerator() {
			return iterator();
		}

        public override IList<T> GetRange(int index, int count) {
            List<T> list = new List<T>();
            return list as IList<T>;
        }

        // Inserts the elements of the given collection at a given index. If
        // required, the capacity of the list is increased to twice the previous
        // capacity or the new size, whichever is larger.  Ranges may be added
        // to the end of the list by setting index to the List's size.
        //
        public override void InsertRange(int index, IEnumerable<T> collection) {

        }


		public override void Insert (int index, T item) {
			GLib.assert (index >= 0 && index <= _size);

			if (_size == _items.length) {
				grow_if_needed (1);
			}
			shift (index, 1);
			_items[index] = item;
			_stamp++;
		}

        // Returns the index of the last occurrence of a given value in a range of
        // this list. The list is searched backwards, starting at the end 
        // and ending at the first element in the list. The elements of the list 
        // are compared to the given value using the Object.Equals method.
        // 
        // This method uses the Array.LastIndexOf method to perform the
        // search.
        // 
        public override int LastIndexOf(T item)
        {
           return -1;
        }


		public override bool Remove (T item) {
			for (int index = 0; index < _size; index++) {
				if (_equal_func (_items[index], item)) {
					RemoveAt (index);
					return true;
				}
			}
			return false;
		}

		public override void RemoveAt (int index) {
			GLib.assert (index >= 0 && index < _size);
			_items[index] = null;
			shift (index + 1, -1);
			_stamp++;
		}

        // This method removes all items which matches the predicate.
        // The complexity is O(n).   
        public override int RemoveAll(Predicate<T> match) {
            int result = size;
            return result;
        }

        // Removes a range of elements from this list.
        // 
        public override void RemoveRange(int index, int count) {
        }
    
        // Reverses the elements in this list.
        public override void Reverse() {
        }
    

        // Sorts the elements in this list.  Uses Array.Sort with the
        // provided comparer.
        public override void Sort(IComparer<T>? comparer = null)
        {
        }

        // Sets the capacity of this list to the size of the list. This method can
        // be used to minimize a list's memory overhead once it is known that no
        // new elements will be added to the list. To completely clear a list and
        // release all memory referenced by the list, execute the following
        // statements:
        // 
        // list.Clear();
        // list.TrimExcess();
        // 
        public override void TrimExcess() {
        }    


		private void shift (int start, int delta) {
			GLib.assert (start >= 0 && start <= _size && start >= -delta);
			_items.move (start, start + delta, _size - start);
			_size += delta;
		}

		private void grow_if_needed (int new_count) {
			GLib.assert (new_count >= 0);
			int minimum_size = _size + new_count;
			if (minimum_size > _items.length) {
				// double the capacity unless we add even more items at this time
				set_capacity (new_count > _items.length ? minimum_size : 2 * _items.length);
			}
		}

		private void set_capacity (int value) {
			GLib.assert (value >= _size);
			_items.resize (value);
		}

		private class Enumerator<T> : GLib.Object, System.Collections.IEnumerator, IEnumerator<T>  {
			public List<T> list {
				set {
					_list = value;
					_stamp = _list._stamp;
				}
			}

			private List<T> _list;
			private int _index = -1;

			// concurrent modification protection
			public int _stamp = 0;

			public Enumerator (List list) {
				this.list = list;
			}

			public bool next () {
				GLib.assert (_stamp == _list._stamp);
				if (_index < _list._size) {
					_index++;
				}
				return (_index < _list._size);
			}

			public new T? get () {
				GLib.assert (_stamp == _list._stamp);

				if (_index < 0 || _index >= _list._size) {
					return null;
				}

				return _list.get (_index);
			}


            public void Dispose() {

            }

            public bool MoveNext() {
				return next();
            }

            private bool MoveNextRare()
            {                
				return next();
            }

            public new T Current {
                owned get {
                    return _list.get (_index);
                }
            }
            
            public void Reset() {
			
			}

		}

    }
}

