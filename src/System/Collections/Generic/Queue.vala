// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

/*=============================================================================
**
**
** Purpose: A circular-array implementation of a generic queue.
**
**
=============================================================================*/
using System;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;

namespace System.Collections.Generic
{
    // A simple Queue of generic objects.  Internally it is implemented as a 
    // circular buffer, so Enqueue can be O(n).  Dequeue is O(1).

    public class Queue<T> :
		GLib.Object,
		IEnumerable<T>,
		ICollection<T>,
        IReadOnlyCollection<T>
    {
        private T[] _array;
        private int _head;       // First valid element in the queue
        private int _tail;       // Last valid element in the queue
        private int _size;       // Number of elements.
        private int _version;
        private GLib.Object _syncRoot;

        private const int MinimumGrow = 4;
        private const int GrowFactor = 200;  // double each time
        private const int DefaultCapacity = 4;

        // Fills a Queue with the elements of an ICollection.  Uses the enumerator
        // to get each of the elements.
        //
        public Queue (IEnumerable<T>? collection = null)
        {
            _array = new T[DefaultCapacity];
			if (collection != null) {
				IEnumerator<T> en = collection.GetEnumerator();
				while (en.MoveNext()) {
					Enqueue(en.Current);
				}
			}
        }

        public int Count
        {
            get { return _size; }
        }

        public bool IsReadOnly {
			get { return false; }
		}

        public bool IsSynchronized
        {
            get { return false; }
        }

        public GLib.Object SyncRoot
        {
            get { return this as GLib.Object; }
        }
        
        public int size
        {
            get { return _size; }
		}

        public new T? get (int item) {
			return _array[item];
		}

        public void Add (T item) {
			Enqueue (item);
		}

        public void Clear()
        {
			
			for (int index = 0; index < _size; index++) {
				_array[index] = null;
			}
			/*
            if (_head < _tail)
                Array.Clear(_array, _head, _size);
            else
            {
                Array.Clear(_array, _head, _array.Length - _head);
                Array.Clear(_array, 0, _tail);
            }*/
            _head = 0;
            _tail = 0;
            _size = 0;
            _version++;
        }

		public bool contains (T item) {
			return Contains(item);
		}

        public bool Contains(T? item)
        {
            int index = _head;
            int count = _size;

            IEqualityComparer<T> c = EqualityComparer<T>.Default();
            while (count-- > 0)
            {
                if ((item) == null)
                {
                    if ((_array[index]) == null)
                        return true;
                }
                else if (_array[index] != null && c.Equals(_array[index], item))
                {
                    return true;
                }
                index = (index + 1) % _array.length;
            }

            return false;
        }


        public void CopyTo(T[] array, int arrayIndex = 0)
			requires (arrayIndex >= 0 || arrayIndex < array.length)
			requires (array.length - arrayIndex >= _size)
        {
            int arrayLen = array.length;
            int numToCopy = (arrayLen - arrayIndex < _size) ? (arrayLen - arrayIndex) : _size;
            if (numToCopy == 0) return;
            int firstPart = (_array.length - _head < numToCopy) ? _array.length - _head : numToCopy;
            
			//Array.Copy(_array, _head, array, arrayIndex, firstPart);
            for (int i = _head; i < _head + firstPart; i++) { 
				array[arrayIndex++] = _array[i];
			}
            
            numToCopy -= firstPart;
            if (numToCopy > 0) {
                //Array.Copy(_array, 0, array, arrayIndex + _array.length - _head, numToCopy);
                int newIndex = arrayIndex + _array.length;
				for (int i = 0; i < numToCopy; i++) { 
					array[newIndex++] = _array[i];
				}
            }
        }


        // Adds item to the tail of the queue.
        //
        public void Enqueue(T item)
        {
            if (_size == _array.length)
            {
                int newcapacity = (int)((long)_array.length * (long)GrowFactor / 100);
                if (newcapacity < _array.length + MinimumGrow)
                {
                    newcapacity = _array.length + MinimumGrow;
                }
                SetCapacity(newcapacity);
            }

            _array[_tail] = item;
            _tail = (_tail + 1) % _array.length;
            _size++;
            _version++;
        }

        internal T GetElement(int i)
        {
            return _array[(_head + i) % _array.length];
        }


        // GetEnumerator returns an IEnumerator over this Queue.  This
        // Enumerator will support removing.
        // 
        public IEnumerator<T> GetEnumerator()
        {
            return new Enumerator<T>(this);
        }

        public IEnumerator<T> iterator()
        {
            return GetEnumerator();
        }


        // Removes the Object at the head of the queue and returns it. If the queue
        // is empty, this method simply returns null.
        public T? Dequeue()
			requires (_size > 0)
        {
            T removed = _array[_head];
            _array[_head] = null; //default(T);
            _head = (_head + 1) % _array.length;
            _size--;
            _version++;
            return removed;
        }

        // Returns theObjectat the head of the queue. TheObjectremains in the
        // queue. If the queue is empty, this method throws an 
        // InvalidOperationException.
        public T Peek()
			requires (_size > 0)
        {
            return _array[_head];
        }

        public bool Remove(T item) {
			GLib.assert_not_reached();
		}

        // PRIVATE Grows or shrinks the buffer to hold capacity objects. Capacity
        // must be >= _size.
        private void SetCapacity(int capacity)
        {
            T[] newarray = new T[capacity];
            if (_size > 0) {
                if (_head < _tail) {
                    //Array.Copy(_array, _head, newarray, 0, _size);
                   int newstart = 0;
                   for (int i = _head; i < _size; i++) { 
						newarray[newstart++] = _array[i];
					}
                } else {
                    //Array.Copy(_array, _head, newarray, 0, _array.Length - _head);
                   int newstart = 0;
                   for (int i = _head; i < _array.length - _head; i++) { 
						newarray[newstart++] = _array[i];
					}
                    //Array.Copy(_array, 0, newarray, _array.Length - _head, _tail);
                   newstart = _array.length - _head;
                   for (int i = 0; i < _tail; i++) { 
						newarray[0] = _array[i];
					}
                }
            }
            _array = newarray;
            _head = 0;
            _tail = (_size == capacity) ? 0 : _size;
            _version++;
        }


        // Iterates over the objects in the queue, returning an array of the
        // objects in the Queue, or an empty array if the queue is empty.
        // The order of elements in the array is first in to last in, the same
        // order produced by successive calls to Dequeue.
        public T[] ToArray()
        {
            T[] arr = new T[_size];
            if (_size == 0)
                return arr;

            if (_head < _tail) {
                //Array.Copy(_array, _head, arr, 0, _size);
				int newstart = 0;
				for (int i = _head; i < _size; i++) { 
					arr[newstart++] = _array[i];
				}
            } else {
                //Array.Copy(_array, _head, arr, 0, _array.Length - _head);
				int newstart = 0;
				for (int i = _head; i < _array.length - _head; i++) { 
					arr[newstart++] = _array[i];
				}
                //Array.Copy(_array, 0, arr, _array.Length - _head, _tail);
                newstart = _array.length - _head;
				for (int i = 0; i < _tail; i++) { 
					arr[newstart++] = _array[i];
				}
            }

            return arr;
        }

        public void TrimExcess()
        {
            int threshold = (int)(((double)_array.length) * 0.9);
            if (_size < threshold)
            {
                SetCapacity(_size);
            }
        }


        // Implements an enumerator for a Queue.  The enumerator uses the
        // internal version number of the list to ensure that no modifications are
        // made to the list while an enumeration is in progress.

		//[Compact]
        public class Enumerator<T> : GLib.Object, IEnumerator<T>
        {
            private Queue<T> _q;
            private int _index;   // -1 = not started, -2 = ended/disposed
            private int _version;
            private T _currentElement;

            public T Current
            {
                owned get
                {
                    return _currentElement;
                }
            }

            internal Enumerator(Queue<T> q)
            {
                _q = q;
                _version = _q._version;
                _index = -1;
                _currentElement = null; //= default(T);
            }

            public void Dispose()
            {
				_index = -2;
                _currentElement = null; //= default(T);
            }

            public bool MoveNext()
				requires (_version == _q._version)
            {
                if (_index == -2)
                    return false;

                _index++;

                if (_index == _q._size)
                {
                    _index = -2;
                    _currentElement = null; //= default(T);
                    return false;
                }
                _currentElement = _q.GetElement(_index);
                return true;
            }

            void Reset()
				requires (_version == _q._version)
            {
                _currentElement = null; //= default(T);
            }
        }
    }
}
