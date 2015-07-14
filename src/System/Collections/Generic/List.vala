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

    // Implements a variable-size List that uses an array of objects to store the
    // elements. A List has a capacity, which is the allocated length
    // of the internal array. As elements are added to a List, the capacity
    // of the List is automatically increased as required by reallocating the
    // internal array.
    // 

    public class List<T> :
		Gee.ArrayList<T>,
		IList<T>,
		ICollection<T>,
		IEnumerable<T>,
		System.Collections.IList,
		System.Collections.IEnumerable,
		System.Collections.ICollection,
		IReadOnlyList<T>,
		IReadOnlyCollection<T>
    {
            
        // Constructs a List. The list is initially empty and has a capacity
        // of zero. Upon adding the first element to the list the capacity is
        // increased to 16, and then increased in multiples of two as required.

        public List(int defaultSize = 0) {
			
        }
    
        public virtual bool IsFixedSize { get { return false; } }
              
        // Gets and sets the capacity of this list.  The capacity is the size of
        // the internal array used to hold items.  When set, the internal 
        // array of the list is reallocated to the given capacity.
        // 
        public int Capacity {
            get { return size; }
            set { }
        }
            
        // Read-only property describing how many elements are in the List.
        public int Count {
            get { return size; }
        }

           
        // Is this List read-only?
        bool IsReadOnly {
            get { return false; }
        }


        // Is this List synchronized (thread-safe)?
        bool IsSynchronized {
            get { return false; }
        }
    
        // Synchronization root for this object.
        Object SyncRoot {
            get { return this as Object; }
        }

        private static bool IsCompatibleObject( Object value) {
            // Non-null values are fine.  Only accept nulls if T is a class or Nullable<U>.
            // Note that default(T) is not equal to null for value types except when T is Nullable<U>. 
            return true;
        }

        // Adds the given Object to the end of this list. The size of the list is
        // increased by one. If required, the capacity of the list is doubled
        // before adding the new element.
        //
        /*
        public new int Add(T item) {
			return -1;
        }
		*/

        // Adds the elements of the given collection to the end of this list. If
        // required, the capacity of the list is increased to twice the previous
        // capacity or the new size, whichever is larger.
        //
        public void AddRange(IEnumerable<T> collection) {
            InsertRange(size, collection);
        }

		/*
        public ReadOnlyCollection<T> AsReadOnly() {
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
        public int BinarySearch(int index, int count, T item, IComparer<T> comparer) {
			return -1;
        }

    
        // Clears the contents of List.
        public virtual void Clear() {
			clear();
        }
    
        // Contains returns true if the specified element is in the List.
        // It does a linear, O(n) search.  Equality is determined by calling
        // item.Equals().
        //
        public virtual bool Contains(T item) {
			return contains (item);
        }

        // Ensures that the capacity of this list is at least the given minimum
        // value. If the currect capacity of the list is less than min, the
        // capacity is increased to twice the current capacity or to min,
        // whichever is larger.
        private void EnsureCapacity(int min) {
        }
   

        public void ForEach(Action<T> action) {
        }

        // Returns an enumerator for this list with the given
        // permission for removal of elements. If modifications made to the list 
        // while an enumeration is in progress, the MoveNext and 
        // GetObject methods of the enumerator will throw an exception.
        //
        public IEnumerator<T> GetEnumerator() {
            return new Enumerator<T>(this);
        }

        public List<T> GetRange(int index, int count) {
            List<T> list = new List<T>(count);
            return list;
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
        public virtual int IndexOf(T item, int index = 0) {
			return -1;
        }

        // Inserts an element into this list at a given index. The size of the list
        // is increased by one. If required, the capacity of the list is doubled
        // before inserting the new element.
        // 
        public virtual void Insert(int index, T item) {
        }
    
        // Inserts the elements of the given collection at a given index. If
        // required, the capacity of the list is increased to twice the previous
        // capacity or the new size, whichever is larger.  Ranges may be added
        // to the end of the list by setting index to the List's size.
        //
        public void InsertRange(int index, IEnumerable<T> collection) {
        }
    
        // Returns the index of the last occurrence of a given value in a range of
        // this list. The list is searched backwards, starting at the end 
        // and ending at the first element in the list. The elements of the list 
        // are compared to the given value using the Object.Equals method.
        // 
        // This method uses the Array.LastIndexOf method to perform the
        // search.
        // 
        public int LastIndexOf(T item)
        {
           return -1;
        }

        public bool Remove(T item) {
            return false;
        }

        // This method removes all items which matches the predicate.
        // The complexity is O(n).   
        public int RemoveAll(Predicate<T> match) {
            int result = size;
            return result;
        }

        // Removes the element at the given index. The size of the list is
        // decreased by one.
        // 
        public virtual void RemoveAt(int index) {
        }
    
        // Removes a range of elements from this list.
        // 
        public void RemoveRange(int index, int count) {
        }
    
        // Reverses the elements in this list.
        public void Reverse() {
        }
    

        // Sorts the elements in this list.  Uses Array.Sort with the
        // provided comparer.
        public void Sort(IComparer<T>? comparer = null)
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
        public void TrimExcess() {
        }    


        public class Enumerator<T> : Object, IEnumerator<T>, System.Collections.IEnumerator, System.IDisposable
        {
			public Object _currentElement { get; set;}
			public Gee.Iterator<T> _iterator { get; set;}
 
            public List<T> list;
            private int index;
            public T current;

            public Enumerator(List<T> list) {
                this.list = list;
                index = 0;
                current = null;
            }

            public void Dispose() {
            }

            public bool MoveNext() {

                List<T> localList = list;
                return MoveNextRare();
            }

            private bool MoveNextRare()
            {                
                index = list.size + 1;
                current = null;
                return false;                
            }

            public T Current {
                get {
                    return current;
                }
            }
            
            public void Reset() {
			
			}

        }
    }
}

