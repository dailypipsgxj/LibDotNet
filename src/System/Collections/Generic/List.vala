// ==++==
// 
//   API Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
/*============================================================
**
** Class:  List
** Purpose: Implements a generic, dynamically sized list as an 
**          array.
===========================================================*/

namespace System.Collections.Generic {

    using System;
    using System.Runtime;
    //using System.Runtime.Versioning;
    using System.Diagnostics;
    using System.Diagnostics.Contracts;
    using System.Collections.ObjectModel;
    using System.Security.Permissions;
	using System.Linq;

	public abstract class AbstractList<T> :
		Enumerable<T>,
		IEnumerable<T>,
		ICollection<T>,
   		IList<T>,
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
        public abstract ReadOnlyCollection<T> AsReadOnly();
        public abstract int BinarySearch(int index, int count, T item, IComparer<T> comparer);
		public abstract void Clear ();
        public abstract void CopyTo(T[] array, int arrayIndex = 0);
        public abstract bool Exists(Predicate<T> match);
        public abstract T? Find(Predicate<T> match);
        public abstract List<T> FindAll(Predicate<T> match); 
        public abstract int FindIndex(Predicate<T> match);
        public abstract T? FindLast(Predicate<T> match);
        public abstract int FindLastIndex(Predicate<T> match);
        public abstract void ForEach(Action<T> action);
        public abstract IEnumerator<T> GetEnumerator();
        public abstract List<T> GetRange(int index, int count);
        public abstract void InsertRange(int index, IEnumerable<T> collection);
		public abstract void Insert (int index, T? item);
        public abstract int LastIndexOf(T item);
		public abstract bool Remove (T item);
		public abstract void RemoveAt (int index);
        public abstract int RemoveAll(Predicate<T> match);
        public abstract void RemoveRange(int index, int count);
        public abstract void Reverse();
        public abstract void Sort(IComparer<T>? comparer = null);
        public abstract T[] ToArray();
        public abstract void TrimExcess();
		public abstract bool TrueForAll(Predicate<T> match);
	}
	
    // Implements a variable-size List that uses an array of objects to store the
    // elements. A List has a capacity, which is the allocated length
    // of the internal array. As elements are added to a List, the capacity
    // of the List is automatically increased as required by reallocating the
    // internal array.
    // 
    public class List<T> : AbstractList<T>
	{
            
		internal T[] _items = new T[4];
		internal int _size;
		private EqualityComparer<T> _equal_func;
		private Comparer<T> _compare_func;
		// concurrent modification protection
		private int _stamp = 0;

        // Constructs a List. The list is initially empty and has a capacity
        // of zero. Upon adding the first element to the list the capacity is
        // increased to 16, and then increased in multiples of two as required.
        public List(IEnumerable<T>? enumerable = null) {
			_equal_func = EqualityComparer<T>.Default();
			_compare_func = Comparer<T>.Default();
			
			if (typeof(T).is_a(typeof(IEqualityComparer<T>))) {
				
			}
			
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
        public override bool IsReadOnly { get { return false; } }

        // Is this List synchronized (thread-safe)?
        public override bool IsSynchronized { get { return false; } }
    
        // Synchronization root for this object.
        public override GLib.Object SyncRoot {
            get { return this as GLib.Object; }
        }

		public override IEnumerator<T> iterator () {
			return new Enumerator<T> (this);
		}

		public override bool contains (T item) {
			return (IndexOf (item) != -1);
		}
 
        public override int IndexOf(T item, int startIndex = 0) {
			for (int index = startIndex; index < _size; index++) {
				if (_equal_func.Equals (_items[index], item)) {
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

		
        public override ReadOnlyCollection<T> AsReadOnly() {
            return new ReadOnlyCollection<T>(this);
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

        public override void CopyTo(T[] array, int arrayIndex = 0)
			requires (array.length >= _size + arrayIndex)
		{
			for (int index = 0; index < _size; index++) {
				array[index + arrayIndex] = _items[index];
			}
		}

        public override bool Exists(Predicate<T> match) {
			return FindIndex(match) != -1;
		}

        public override T? Find(Predicate<T> match) {
            for(int i = 0 ; i < _size; i++) {
                if(match(_items[i])) {
                    return _items[i];
                }
            }
			return null;
		}
		
        public override List<T> FindAll(Predicate<T> match) { 
            List<T> list = new List<T>(); 
            for(int i = 0 ; i < _size; i++) {
                if(match(_items[i])) {
                    list.Add(_items[i]);
                }
            }
            return list;
        }

		
        public override int FindIndex(Predicate<T> match) {
            for( int i = 0; i < _size; i++) {
                if( match(_items[i])) return i;
            }
            return -1;
		}

        public override T? FindLast(Predicate<T> match) {
            for(int i = _size - 1 ; i >= 0; i--) {
                if(match(_items[i])) {
                    return _items[i];
                }
            }
            return null;
        }

        public override int FindLastIndex(Predicate<T> match) {
			int startIndex = _size - 1;
			int count = _size;
            int endIndex = startIndex - count;
            for( int i = startIndex; i > endIndex; i--) {
                if( match(_items[i])) {
                    return i;
                }
            }
            return -1;
        }


        public override void ForEach(Action<T> action) {
            for(int i = 0 ; i < _size; i++) {
                action(_items[i]);
            }
        }

        public override IEnumerator<T> GetEnumerator() {
			return iterator();
		}

        public override List<T> GetRange(int index, int count) {
            List<T> list = new List<T>.WithCapacity(count);
            for (int i = index; i < index + count; i++) {
				list.Add(_items[i]);
			}
            return list;
        }


        // Inserts the elements of the given collection at a given index. If
        // required, the capacity of the list is increased to twice the previous
        // capacity or the new size, whichever is larger.  Ranges may be added
        // to the end of the list by setting index to the List's size.
        //
        public override void InsertRange(int index, IEnumerable<T> collection) {
			foreach (var item in collection) {
				Insert(index++, item);
			}
        }


		public override void Insert (int index, T? item) {
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
			return FindLastIndex((x) => _equal_func.Equals(x, item));
        }


		public override bool Remove (T item) {
			for (int index = 0; index < _size; index++) {
				if (_equal_func.Equals (_items[index], item)) {
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
            int freeIndex = 0;   // the first free slot in items array

            // Find the first item which needs to be removed.
            while( freeIndex < _size && !match(_items[freeIndex])) freeIndex++;            
            if( freeIndex >= _size) return 0;
            
            int current = freeIndex + 1;
            while( current < _size) {
                // Find the first item which needs to be kept.
                while( current < _size && match(_items[current])) current++;            

                if( current < _size) {
                    // copy item to the free slot.
                    _items[freeIndex++] = _items[current++];
                }
            }                       
            int result = _size - freeIndex;
         
            for (int i = freeIndex; i < _size; i++) {
				RemoveAt(i);
			}
            //Array.Clear(_items, freeIndex, _size - freeIndex);
            _size = freeIndex;
            _stamp++;
            return result;
        }

        // Removes a range of elements from this list.
        // 
        public override void RemoveRange(int index, int count) {
             if (count > 0) {
                //_size -= count;
                if (index < _size) {
					for (int i = index; i < index+count; i++) {
						RemoveAt(index);
					}
                }
                _stamp++;
            }
       }
    
        // Reverses the elements in this list.
        public override void Reverse() {
            int index = 0;
            int length = _size;
            int i = index;
            int j = index + length - 1;

			while (i < j) {
				T temp = _items[i];
				_items[i] = _items[j];
				_items[j] = temp;
				i++;
				j--;
			}
        }
    

        // Sorts the elements in this list.  Uses Array.Sort with the
        // provided comparer.
        public override void Sort(IComparer<T>? comparer = null)
        {
			//GLib.CompareDataFunc compare_func = GLib.Functions.get_compare_func_for (typeof (T));
			TimSort.sort<T> (this,(GLib.CompareDataFunc) GLib.strcmp);
        }

        // ToArray returns a new Object array containing the contents of the List.
        // This requires copying the List, which is an O(n) operation.
        public override T[] ToArray() {
            T[] array = new T[_size];
            CopyTo(array);
            return array;
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
			int threshold = (int)(((double)_items.length) * 0.9);
            if( _size < threshold ) {
                Capacity = _size;                
            }
        }    

        public override bool TrueForAll(Predicate<T> match) {
            for(int i = 0 ; i < _size; i++) {
                if( !match(_items[i])) {
                    return false;
                }
            }
            return true;
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
			if(value < _size)
				throw new ArgumentOutOfRangeException.VALUE("Value is lower than current List size");
			_items.resize (value);
		}

		internal class Enumerator<T> : Enumerable<T>, IEnumerator<T>  {

			private List<T> _list;
			private int _index = -1;
			// concurrent modification protection
			public int _stamp = 0;

			public Enumerator (List list) {
				this.list = list;
			}

			public List<T> list {
				set {
					_list = value;
					_stamp = _list._stamp;
				}
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

