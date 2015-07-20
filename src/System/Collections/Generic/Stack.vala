// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

/*=============================================================================
**
**
** Purpose: An array implementation of a generic stack.
**
**
=============================================================================*/
using System;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;

namespace System.Collections.Generic
{
    // A simple stack of objects.  Internally it is implemented as an array,
    // so Push can be O(n).  Pop is O(1).

    public class Stack<T> : GLib.Object, IEnumerable<T>, ICollection<T>, IReadOnlyCollection<T>
    {
        private T[] _array;     // Storage for stack elements
        private int _size;           // Number of items in the stack.
        private int _version;        // Used to keep enumerator in sync w/ collection.
        private GLib.Object _syncRoot;

        private const int DefaultCapacity = 4;

        // Create a stack with a specific initial capacity.  The initial capacity
        // must be a non-negative number.
        public Stack.WithCapacity(int capacity)
        {
            _array = new T[capacity];
        }

        // Fills a Stack with the contents of a particular collection.  The items are
        // pushed onto the stack in the same order they are read by the enumerator.
        //
        public Stack(IEnumerable<T>? collection = null)
        {
            _array = new T[DefaultCapacity];
            
            if (collection != null)
				foreach (T item in collection)
					Push (item);
        }
        
        public void Add (T item) {
			Push (item);
		}


        public int Count{
            get { return _size; }
        }

        public bool IsReadOnly {
			get { return false; }
		}

        public bool IsSynchronized {
            get { return false; }
        }

        public GLib.Object SyncRoot {
            get { return this as GLib.Object; }
        }

        // Removes all Objects from the Stack.
        public void Clear()
        {
			for (int index = 0; index < _size; index++) {
				_array[index] = null;
			}
            _size = 0;
            _version++;
        }

		public bool contains (T item) {
			return Contains(item);
		}
		
		public int size
        {
            get { return _size; }
		}


        public bool Contains(T item)
        {
            int count = _size;
            EqualityComparer<T> c = EqualityComparer<T>.Default();
            while (count-- > 0)
            {
                if ((item) == null)
                {
                    if ((_array[count]) == null)
                        return true;
                }
                else if (_array[count] != null && c.Equals(_array[count], item))
                {
                    return true;
                }
            }
            return false;
        }

        public void CopyTo(T[] array, int arrayIndex)
			requires (arrayIndex >= 0 || arrayIndex < array.length)
			requires (array.length - arrayIndex >= _size)
        {
			int srcIndex = 0;
			int dstIndex = arrayIndex + _size;
			for (int i = 0; i < _size; i++)
				array[--dstIndex] = _array[srcIndex++];
		}
        
        public new virtual T? get (int item) {
			return _array[item];
		}
        
        IEnumerator<T> GetEnumerator()
        {
            return new Enumerator<T>(this);
        }

        IEnumerator<T> iterator()
        {
            return GetEnumerator();
        }

        public bool Remove(T item) {
			GLib.assert_not_reached();
		}



        public void TrimExcess()
        {
			int threshold = (int)(((double)_array.length) * 0.9);
            if (_size < threshold)
            {
                _array.resize(_size);
                _version++;
            }

        }

        // Returns the topObjecton the stack without removing it.  If the stack
        // is empty, Peek throws an InvalidOperationException.
        public T Peek()
			requires (_size > 0)
        {
            return _array[_size - 1];
        }

        // Pops an item from the top of the stack.  If the stack is empty, Pop
        // throws an InvalidOperationException.
        public T Pop()
			requires (_size > 0)
        {
            _version++;
            T item = _array[--_size];
            _array[_size] = null;//default(T);     // Free memory quicker.
            return item;
        }

        // Pushes an item to the top of the stack.
        // 
        public void Push(T item)
        {
            if (_size == _array.length) {
                _array.resize((_array.length == 0) ? DefaultCapacity : 2 * _array.length);
            }
            _array[_size++] = item;
            _version++;
        }

        // Copies the Stack to an array, in the same order Pop would return the items.
        public T[] ToArray()
        {
            T[] objArray = new T[_size];
            int i = 0;
            while (i < _size)
            {
                objArray[i] = _array[_size - i - 1];
                i++;
            }
            return objArray;
        }

		//[Compact]
        public class Enumerator<T> : GLib.Object, IEnumerator<T>
        {
            private Stack<T> _stack;
            private int _index;
            private int _version;
            private T _currentElement;
            
            public Enumerator(Stack<T> stack)
            {
                _stack = stack;
                _version = _stack._version;
                _index = -2;
                _currentElement = null; //default(T);
            }

            public void Dispose()
            {
                _index = -1;
            }

			public new T get () {
				return Current;
			}
		
            public T Current
            {
                owned get
                {
                    return _currentElement;
                }
            }

            public bool MoveNext()
				requires (_version == _stack._version)
            {
                bool retval;
                if (_index == -2) {
                    _index = _stack._size - 1;
                    retval = (_index >= 0);
                    if (retval)
                        _currentElement = _stack._array[_index];
                    return retval;
                }

                if (_index == -1)
					return false;

                retval = (--_index >= 0);
                if (retval)
                    _currentElement = _stack._array[_index];
                else
                    _currentElement = null; //default(T);
                return retval;
            }

            void Reset()
            {
                _index = -2;
                _currentElement = null; //default(T);
            }
        }
    }
}
